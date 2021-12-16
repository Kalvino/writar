module Student::OrdersHelper
  # @return [Object]
  def label_for_order(order)
    case order.status
      when "pending_quote" then '<span class="label label-info">Pending Quote</span>'
      when "pending_payment" then '<span class="label label-warning">Pending Payment</span>'
      when "in_progress" then '<span class="label label-success">In Progress</span>'
      when "completed" then '<span class="label label-primary">Completed</span>'
      when "cancelled" then '<span class="label label-danger">Cancelled</span>'
    end
  end

  def simple_filename(original_name)
    name, ext = original_name.split(".")
    return original_name if original_name.length < 20
    short_name = truncate(name, length: 18, omission: '[..]')
    "#{short_name}.#{ext}"
  end
end
