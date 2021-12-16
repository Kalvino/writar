class PurchasesDatatable
  delegate :params, :h, :link_to, :content_tag, :truncate, :number_to_currency, :concat, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Purchase.count,
        iTotalDisplayRecords: purchases.total_entries,
        aaData: data,
        mapData: map_data
    }
  end

  private

  def data
    purchases.map do |purchase|
      [
          purchase.payer_name.titleize,
          purchase.payer_email,
          link_to(truncate(purchase.essay.title, length: 20), [:admin, purchase.essay]),
          content_tag(:span, class: label_class_for(purchase)) do
            number_to_currency(purchase.mc_gross)
          end,
          purchase.created_at.strftime("%d %b %Y at %I:%M%p"),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, [:admin, purchase], class: "btn-white btn btn-xs"))
          end
      ]
    end
  end

  def purchases
    @purchases ||= fetch_purchases
  end

  def fetch_purchases
    purchases = Purchase.includes(:essay).order("#{sort_column} #{sort_direction}")
    purchases = purchases.page(page).per_page(per_page)
    if params[:sSearch].present?
      purchases = purchases.where("first_name iLike :search OR last_name iLike :search OR payer_email iLike :search OR payment_status iLike :search", search: "%#{params[:sSearch]}%")
    end
    purchases
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[first_name payer_email "" mc_gross created_at ]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end

  def map_data
    @data ||= Purchase.year(Date.today.year).group_by(&:residence_country).each_with_object({}) do |(country_code, purchases), data|
      data[country_code] = purchases.count
    end
  end

  def label_class_for(purchase)
    case purchase.payment_status
      when "Completed"
        "label label-primary"
      when "Pending"
        "label label-warning"
      when "Refunded"
        "label label-danger"
      else
        "label label-info"
    end
  end
end
