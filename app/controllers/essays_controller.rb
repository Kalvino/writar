class EssaysController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:ipn]

  def index
    add_breadcrumb "Papers", :essays_path
    if params[:query]
      add_breadcrumb "Search", :essays_path
      add_breadcrumb params[:query][0..100], :essays_path
      begin
        query = sanitize_query(params[:query])
        @essays = Essay.search query, fields: [:title,:question], limit: 6
        # @essays = Essay.search(query).records.approved.recent.page(params[:page])
      rescue Exception => e
        flash[:alert] = "Oops! Something went wrong while performing search. Please try again"
        SlackBot.notify("Elastic Search Error","Search Error", e.message)
        @essays = Essay.approved.recent.page(params[:page])
      end
    else
      @essays = Essay.approved.recent.page(params[:page])
    end

    @categories ||= Category.all
    @active_section = :essays

    respond_to do |format|
      format.html
      format.json { render json: response_for(@essays) }
    end
  end

  def show
    add_breadcrumb "Papers", :essays_path

    @essay = Essay.friendly.find(params[:id])
    @related_essays = @essay.category.essays.where.not(id: @essay.id).approved.recent.limit(3)
    add_breadcrumb @essay.title, @essay
    @active_section = :essays
    if request.path != essay_path(@essay)
      redirect_to @essay, status: :moved_permanently
    end
  end

  def category
    add_breadcrumb "Papers", :essays_path

    @category = Category.friendly.find(params[:category])
    @essays = @category.essays.approved.recent.page(params[:page])
    @categories = Category.all

    add_breadcrumb "Category", "#"
    add_breadcrumb "#{@category.name}", "#"
    @active_section = :essays
  end

  def purchase
    @essay = Essay.friendly.find(params[:id])
    @paypal = PaypalInterface.new(@essay)
    @paypal.express_checkout
    @paypal_url = @paypal.api.express_checkout_url(@paypal.express_checkout_response)
    if @paypal.express_checkout_response.success?
      session[:purchase_essay_id] = @essay.id
      redirect_to @paypal_url
    else
      redirect_to @essay, alert: "Something wrong happened. Please try again"
    end
  end

  def paid
    @essay  = Essay.find(session[:purchase_essay_id])
    key     = Digest::MD5.hexdigest(params[:token])
    record  = JSON.parse $redis.get(key)
    record[:payer_id] = params[:PayerID]
    $redis.set(key, record.to_json)
    PaypalWorker.perform_async(@essay.id, key)
    session[:essay_id] = @essay.id
    redirect_to @essay, notice: "Your payment was successfully received!"
  end

  def revoked
    @essay = Essay.find(session[:purchase_essay_id])
    redirect_to @essay, alert: "No payment was received. Click the pay button at any time to make a payment"
  end

  def ipn
    if params[:parent_txn_id]
      purchase = Purchase.find_by_txn_id(params[:parent_txn_id])
      if purchase.nil?
        SlackBot.notify("Cannot find purchase with txn_id #{params[:parent_txn_id]}","txn not found error","Purchase record is nil")
      else
        purchase.update(ipn_params.except(:parent_txn_id))
      end
    else
      purchase = Purchase.find_by_txn_id(params[:txn_id])
      if purchase.nil?
        SlackBot.notify("Cannot find purchase with txn_id #{params[:txn_id]}","txn not found error","Purchase record is nil")
      else
        purchase.update(ipn_params)
        MailchimpWorker.perform_async(purchase.id, "purchase")
        NotificationMailer.delay.send_paper(purchase)
        IntercomWorker.perform_async("purchase", purchase.id)
      end
    end
    render json: {}, status: :ok
  end

  def download
    if session[:essay_id]
      @essay = Essay.find(session[:essay_id])
      Essay.increment_counter(:download_count, @essay.id)
      session.delete(:essay_id)
      file = open(@essay.document.url).read
      send_data file, filename: @essay.adjusted_document_name, type: @essay.document_content_type, disposition: 'attachment'
    else
      redirect_to essays_path, alert: "Sorry, download link expired."
    end
  end

  private

  def ipn_params
    params.permit(:first_name, :last_name, :payer_email, :payer_id, :txn_id, :parent_txn_id, :residence_country, :payment_status,
                  :payment_date, :payment_token, :mc_fee, :mc_gross, :verify_sign)
  end

  def sanitize_query(str)
    # Escape special characters
    # http://lucene.apache.org/core/old_versioned_docs/versions/2_9_1/queryparsersyntax.html#Escaping Special Characters
    escaped_characters = Regexp.escape('\\+-&|!(){}[]^~*?:\/')

    str = str.gsub(/([#{escaped_characters}])/, '\\\\\1')

    # AND, OR and NOT are used by lucene as logical operators. We need
    # to escape them
    ['AND', 'OR', 'NOT'].each do |word|
      escaped_word = word.split('').map {|char| "\\#{char}" }.join('')
      str = str.gsub(/\s*\b(#{word.upcase})\b\s*/, " #{escaped_word} ")
    end

    # Escape odd quotes
    quote_count = str.count '"'
    str = str.gsub(/(.*)"(.*)/, '\1\"\3') if quote_count % 2 == 1

    str
  end

  def response_for(essays)
    essays.map do |essay|
      { title: essay.title,
        question: ActionController::Base.helpers.strip_tags(essay.question)[0..110] + "...",
        url: essay_path(essay)
      }
    end
  end
end

