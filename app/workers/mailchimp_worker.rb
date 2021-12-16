class MailchimpWorker
  include Sidekiq::Worker

  def perform(id, type = "seller")
    if type == "seller"
      @seller = Seller.find(id)
      $mailchimp.lists(ENV["MAILCHIMP_LIST_ID"]).members.create(body: {email_address: @seller.email, status: "subscribed", merge_fields: {FNAME: @seller.first_name, LNAME: @seller.last_name }})
    elsif type == "purchase"
      @purchase = Purchase.find(id)
      begin
        $mailchimp.lists("cbdd63deb4").members.create(body: {email_address: @purchase.payer_email, status: "subscribed", merge_fields: {FNAME: @purchase.first_name, LNAME: @purchase.last_name }})
      rescue Gibbon::MailChimpError => e
        response = JSON.parse(e.raw_body)
        puts response["detail"]
      end
    end
  end
end
