class SellersDatatable
  delegate :params, :h, :link_to, :content_tag, :concat, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Seller.count,
        iTotalDisplayRecords: sellers.total_entries,
        aaData: data
    }
  end

  private

  def data
    sellers.map do |seller|
      [
          seller.first_name.titleize,
          seller.last_name.titleize,
          seller.email,
          seller.essays_count,
          seller.created_at.strftime("%d %b %Y"),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, [:admin, seller], class: "btn-default btn-white btn btn-xs"))
            concat(link_to("<i class='fa fa-pencil'></i> Edit".html_safe, "#", class: "btn-default btn-white btn btn btn-xs"))
          end
      ]
    end
  end

  def sellers
    @sellers ||= fetch_sellers
  end

  def fetch_sellers
    sellers = Seller.order("#{sort_column} #{sort_direction}")
    sellers = sellers.page(page).per_page(per_page)
    if params[:sSearch].present?
      sellers = sellers.where("first_name iLike :search OR last_name iLike :search OR username iLike :search", search: "%#{params[:sSearch]}%")
    end
    sellers
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[first_name last_name email essays_count created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
