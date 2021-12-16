module Student::StudentsHelper
  def orders_per_day(orders)
    dates = (30.days.ago.beginning_of_day.to_datetime..Time.zone.now.to_datetime).map{|d| d.strftime("%d-%m-%Y") }
    grouped_orders = orders.group_by(&:day)
    dates.each_with_object([]) do |date,arr|
      grouped_orders.has_key?(date) ? arr << grouped_orders[date].count : arr << 0
    end
  end
end
