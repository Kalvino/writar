class Invoice < ActiveRecord::Base
  include Filterable

  belongs_to :order

  validates_presence_of :amount, :order_id

  after_create :update_order_status

  scope :completed, -> { where(payment_status: "Completed") }

  def set_payment_token(token)
    update(payment_token: token)
  end

  def self.revenue
    self.completed.sum(:amount)
  end

  private

  def update_order_status
    self.order.update(status: "pending_payment")
  end
end
