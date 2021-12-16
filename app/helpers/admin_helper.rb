module AdminHelper
  def disk_usage
    disks = `df -h`
    disk = disks.split("\n").select {|d| d.split(" ").last == "/" }[0]
    info = disk.split(" ")
    "#{info[3]} of <strong>#{info[1]}</strong> Free"
  end

  def price_for(purchase)
    span_class = purchase.payment_status == "Completed" ? "label-primary" : "label-warning"
    "<span class='label #{span_class}'>#{number_to_currency(purchase.essay.price)}</span>".html_safe
  end

  def bio(resource, admin=true)
    if resource.is_a?(Seller)
      "#{resource.first_name} joined #{t("sitename")} on #{resource.created_at.strftime(" %d %B, %Y")}. Since then he/she has
     uploaded #{resource.essays_count} papers that have raked in #{number_to_currency(resource.sales)}"
    elsif resource.is_a?(Student)
      if admin
        revenue = resource.orders.completed.includes(:invoice).map(&:amount).sum
        t("bio.student", date: resource.created_at.strftime("#{resource.created_at.day.ordinalize} %B %Y"), username: resource.first_name, orders_count: resource.orders_count, revenue: number_to_currency(revenue))
      else
        "#{admin ? resource.first_name : "You"} joined #{t("sitename")} on #{resource.created_at.strftime("#{resource.created_at.day.ordinalize} %B, %Y")}. Since then #{admin ? "he/she has" : "you have"}
     made #{resource.orders_count} orders"
      end
    elsif resource.is_a?(Writer)
      "Since #{resource.created_at.strftime(" %d %B, %Y")}, #{resource.first_name}  has successfully completed #{resource.orders.completed.count} orders
      with a total payable amount of #{number_to_currency(resource.earnings)}"
    end
  end

  def translate_duration(duration)
    translations = { day: "today", week: "this week", month: "this month", year: "this year"}
    translations[duration]
  end
end
