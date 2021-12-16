module Admin::SellersHelper
  def uploads_per_day(uploads)
    dates = (7.days.ago.beginning_of_day.to_datetime..Time.zone.now.to_datetime).map{|d| d.strftime("%d-%m-%Y") }
    grouped_uploads = uploads.group_by(&:day)
    dates.each_with_object([]) do |date,arr|
      grouped_uploads.has_key?(date) ? arr << grouped_uploads[date].count : arr << 0
    end
  end
end
