class OrdersDatatable
  include Rails.application.routes.url_helpers
  include ActionDispatch::Routing::PolymorphicRoutes

  delegate :params, :h, :link_to, :truncate, :content_tag, :can?, :concat, :number_to_currency, to: :@view

  def initialize(view)
    @view = view
  end

  def as_json(options = {})
    {
        sEcho: params[:sEcho].to_i,
        iTotalRecords: orders_count,
        iTotalDisplayRecords: orders.total_entries,
        aaData: data
    }
  end

  private

  def data
    orders.map do |order|
      [
          link_to("##{order.uid}", polymorphic_path(order_url(order))),
          link_to(truncate(order.topic.titleize, length: 45), polymorphic_path(order_url(order)), title: order.topic, data: { toggle: "tooltip", placement: "right"}),
          order.created_at.strftime("%d %b %Y"),
          label_for(order.status),
          order.due_at.strftime("%d %b %Y at %I:%M%p"),
          content_tag(:div, class: "btn-group", role: "group") do
            concat(link_to("<i class='fa fa-eye'></i> View".html_safe, polymorphic_path(order_url(order)), class: "btn-default btn-white btn btn-xs"))
            concat(link_to("<i class='fa fa-pencil'></i> Edit".html_safe, edit_polymorphic_path(order_url(order)), class: "btn-default btn-white btn btn btn-xs"))
            concat(link_to("<i class='fa fa-trash'></i> Delete".html_safe, polymorphic_path(order_url(order)), method: :delete, data: { confirm: "Are you sure you want to delete this order?"}, class: "btn-default btn-danger btn btn btn-xs")) if params[:is_admin] && can?(:destroy, order)
          end
      ]
    end
  end

  def orders
    @orders ||= fetch_orders
  end

  def fetch_orders
    orders = Order.order("#{sort_column} #{sort_direction}")
    orders = orders.page(page).per_page(per_page)
    if params[:sSearch].present?
      orders = orders.where("uid like :search OR topic iLike :search", search: "%#{params[:sSearch]}%")
    end
    if params[:student_id].present?
      orders = orders.where(student_id: params[:student_id])
    end
    if params[:assigned_to_id].present?
      orders = orders.where(assigned_to_id: params[:assigned_to_id])
    end
    if params[:status].present?
      orders = orders.send(params[:status])
    end
    orders
  end

  def page
    params[:iDisplayStart].to_i/per_page + 1
  end

  def per_page
    params[:iDisplayLength].to_i > 0 ? params[:iDisplayLength].to_i : 25
  end

  def sort_column
    columns = %w[uid topic created_at status due_at]
    columns[params[:iSortCol_0].to_i]
  end

  def sort_direction
    params[:sSortDir_0] == "desc" ? "DESC" : "ASC"
  end

  def label_for(status)
    case status
      when "pending_quote" then '<span class="label label-info">Pending Quote</span>'
      when "pending_payment" then '<span class="label label-warning">Pending Payment</span>'
      when "in_progress" then '<span class="label label-success">In Progress</span>'
      when "completed" then '<span class="label label-primary">Completed</span>'
      when "cancelled" then '<span class="label label-danger">Cancelled</span>'
    end
  end

  def order_url(record)
    if params[:is_admin].present?
      [:admin, record]
    else
      [:student, record]
    end
  end

  def orders_count
    if params[:is_admin].present?
      Order.count
    else
      Student.find(params[:student_id]).orders_count
    end
  end
end
