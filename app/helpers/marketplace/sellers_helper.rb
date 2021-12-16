module Marketplace::SellersHelper
  def timezone(timezone)
    tz = ActiveSupport::TimeZone[timezone]
    "#{tz.tzinfo.name} #{tz.formatted_offset}"
  end
end
