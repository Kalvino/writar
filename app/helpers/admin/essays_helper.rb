module Admin::EssaysHelper
  def options_for_referencing_styles
    ReferencingStyle.all.map {|rs| [rs.name, rs.id]}
  end

  def options_for_categories
    Category.all.map {|c| [c.name, c.id]}
  end

  def embed(essay)
    %Q{<iframe src="https://docs.google.com/gview?url=#{essay.document.url}&embedded=true" width="100%" height="600px;" style="border:none"></iframe>}
  end

  def class_for(status, button)
    status == button ? "active" : ""
  end

  def difference(klass, interval,resp = "html")
    method = [Transaction, Invoice].include?(klass) ? :revenue : :count
    case interval
      when :day
        total_today     = klass.today.send(method)
        total_yesterday = klass.yesterday.send(method)
        div_class, fa_icon, percentage  = change(total_today,total_yesterday)
      when :week
        total_this_week = klass.this_week.send(method)
        total_last_week = klass.between(1.week.ago.beginning_of_week,1.week.ago.end_of_week).send(method)
        div_class, fa_icon, percentage  = change(total_this_week,total_last_week)
      when :month
        total_this_month = klass.this_month.send(method)
        total_last_month = klass.between(1.month.ago.beginning_of_month,1.month.ago.end_of_month).send(method)
        div_class, fa_icon, percentage  = change(total_this_month,total_last_month)
      when :year
        total_this_year = klass.this_year.send(method)
        total_last_year = klass.between(1.year.ago.beginning_of_year,1.year.ago.end_of_year).send(method)
        div_class, fa_icon, percentage  = change(total_this_year,total_last_year)
    end
    return percentage unless resp == "html"
    %Q{<div class="stat-percent font-bold text-navy #{div_class}">#{number_to_percentage(percentage, precision: 0) } #{fa_icon}</div>}
  end

  def change(new_count,old_count)
    div_class  = new_count > old_count ? "" : "text-danger"
    fa_icon    = new_count > old_count ? '<i class="fa fa-level-up"></i>' : '<i class="fa fa-level-down"></i>'
    percentage = old_count == 0 ? 0 : (new_count - old_count).to_f / old_count * 100
    [div_class, fa_icon, percentage]
  end
end
