class Redemption < ActiveRecord::Base
  belongs_to :coupon
  belongs_to :student
  belongs_to :order

  validates_presence_of :coupon_id, :student_id, :order_id
  validates_uniqueness_of :coupon_id, scope: :student_id

  after_create :apply_discount

  private

  def apply_discount
    order       = self.order
    coupon      = self.coupon
    order_cost  = order.cost

    if coupon.coupon_type == "percentage"
      new_cost = order_cost - (order_cost * (coupon.amount.to_f/100) ) # % discount
    elsif coupon.coupon_type == "amount"
      new_cost = order_cost - coupon.amount
    end

    order.invoice.update(amount: new_cost)
    update(description: "Applied coupon code %s (%s) to order #%s. Cost changed from $%.2f to $%.2f" % [coupon.code, coupon.amount_to_s, order.uid, order.cost, order.invoice.amount ])
  end
end
