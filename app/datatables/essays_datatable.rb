class EssaysDatatable
  delegate :params, :h, :link_to, :truncate, :titleize, :can?, :content_tag, :concat, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: essays_count,
        iTotalDisplayRecords: essays.total_entries,
        aaData: data
    }
  end

  private

  def data
    essays.map do |essay|
      [
          link_to(truncate(essay.title.titleize, length: 35), url(essay, :show), title: essay.title, data: { toggle: "tooltip", placement: "right"}),
          number_to_currency(essay.price),
          essay.page_count,
          essay.download_count,
          label_for(essay.status),
          essay.created_at.strftime("%d %b %Y"),
          link_to(essay.owner.name.titleize, [:admin, essay.owner]),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, url(essay, :show), class: "btn-default btn-white btn btn-xs")) if can? :read, essay
            concat(link_to("<i class='fa fa-pencil'></i> Edit".html_safe, url(essay, :edit), class: "btn-default btn-white btn btn btn-xs")) if can? :update, essay
          end
      ]
    end
  end

  def essays
    @essays ||= fetch_essays
  end

  def fetch_essays
    essays = Essay.includes(:owner).order("#{sort_column} #{sort_direction}")
    essays = essays.page(page).per_page(per_page)
    if params[:sSearch].present?
      essays = essays.where("title iLike :search", search: "%#{params[:sSearch]}%")
    end
    if params[:category_id].present?
      essays = essays.where(category_id: params[:category_id])
    end
    if params[:seller_id].present?
      essays = essays.where(owner_id: owner_id(params[:seller_id]), owner_type: "Seller")
    end
    if params[:admin_id].present?
      essays = essays.where(owner_id: owner_id(params[:admin_id]), owner_type: "Admin")
    end
    if params[:status].present?
      essays = essays.send(params[:status])
    end
    essays
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[title price page_count download_count status created_at owner_id]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def url(essay, action)
    if params[:seller_id].present? && !params[:admin].present?
      case action
        when :show then [:marketplace, essay]
        when :edit then Rails.application.routes.url_helpers.edit_marketplace_essay_path(essay)
      end
    else
      case action
        when :show then [:admin, essay]
        when :edit then Rails.application.routes.url_helpers.edit_admin_essay_path(essay)
      end
    end
  end

  def owner_id(crypted_id)
    $crypt.decrypt_and_verify(crypted_id)
  end

  def label_for(status)
    case status
      when "approved" then '<span class="label label-success">Approved</span>'
      when "pending" then '<span class="label label-warning">Pending</span>'
      when "denied" then '<span class="label label-danger">Denied</span>'
    end
  end

  def essays_count
    if params[:seller_id].present? && !params[:admin].present?
      Seller.find(owner_id(params[:seller_id])).essays_count
    else
      Essay.count
    end
  end
end
