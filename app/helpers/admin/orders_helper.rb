module Admin::OrdersHelper
  def icon_for(status)
    icon = case status
             when 'all' then 'database'
             when 'pending_quote' then 'hourglass'
             when 'pending_payment' then 'money'
             when 'in_progress' then 'refresh'
             when 'completed' then 'thumbs-up'
             when 'cancelled' then 'times-circle'
           end
    "<i class='fa fa-#{icon}' style='padding-right: 10px;'></i>".html_safe
  end
end
