class Withdrawal < ActiveRecord::Base
  belongs_to :seller

  validates_presence_of :seller_id, :amount
  validate :minimum_balance

  after_create :update_seller_balance, :send_withdrawal_request

  scope :recent, -> { order("created_at DESC")}

  self.per_page = 25


  def minimum_balance
    unless self.seller.balance > ENV["MINIMUM_REQUEST_AMOUNT"].to_i
      errors.add(:balance, "must be $#{ENV["MINIMUM_REQUEST_AMOUNT"]} or more to request payment")
    end
  end

  private

  def update_seller_balance
    self.seller.transactions.create(txn_type: "Withdrawal", amount: self.amount*-1, description: "Paypal withdrawal")
  end

  def send_withdrawal_request
    NotificationMailer.withdrawal_request(self).deliver!
  end
end
