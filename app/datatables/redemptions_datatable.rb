class RedemptionsDatatable
  include Rails.application.routes.url_helpers

  delegate :params, :h, :link_to, :content_tag, :concat, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: Redemption.count,
        iTotalDisplayRecords: redemptions.total_entries,
        aaData: data
    }
  end

  private

  def data
    redemptions.map do |redemption|
      [
          content_tag(:div) do
            content_tag(:strong) do
              link_to redemption.student.name, admin_student_path(redemption.student)
            end
          end + content_tag(:small, redemption.description),
          redemption.created_at.strftime("%d %B, %Y"),
          link_to("##{redemption.order.uid}", admin_order_path(redemption.order))
      ]
    end
  end

  def redemptions
    @redemptions ||= fetch_redemptions
  end

  def fetch_redemptions
    redemptions = Redemption.order("#{sort_column} #{sort_direction}")
    redemptions = redemptions.page(page).per_page(per_page)
    if params[:sSearch].present?
      redemptions = redemptions.where("description iLike :search", search: "%#{params[:sSearch]}%")
    end
    redemptions
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[id created_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "desc" : "asc"
  end
end
