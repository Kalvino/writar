class Coupon < ActiveRecord::Base
  validates_presence_of :code, :description, :amount, :coupon_type
  validates :coupon_type, inclusion: { in: %w(amount percentage) }

  has_many :redemptions
  has_many :students, through: :redemptions

  def amount_to_s
    coupon_type == "amount" ? "$#{amount.to_i} OFF" : "#{amount.to_i}% OFF"
  end
end
