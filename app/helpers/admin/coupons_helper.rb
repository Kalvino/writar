module Admin::CouponsHelper
  def options_for_coupon_type
    %w(percentage amount).map{|t| [t.titleize, t] }
  end
end
