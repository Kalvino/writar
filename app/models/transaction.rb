class Transaction < ActiveRecord::Base
  extend FriendlyId
  include Filterable
  include Navigatable

  friendly_id :txn_id, use: :slugged

  belongs_to :purchase
  belongs_to :owner, polymorphic: true

  before_create :set_txn_id, :set_before_balance
  after_create :update_owner_balance

  validates_presence_of :amount, :txn_type, :description, :owner_id, :owner_type

  SERVICE_FEE_PERCENTAGE = 0.3

  self.per_page = 25

  # def self.revenue
  #   query = %Q{
  #               SELECT  SUM(revenue) revenue FROM
  #               (
  #                 select sum(amount*-1) revenue from transactions where (txn_type ='Service Fee')
  #                    UNION ALL
  #                 select sum(amount) revenue from transactions where(owner_type ='Admin')
  #               ) s;
  #             }
  #   Transaction.connection.select_all(query).rows.flatten.first.to_f
  # end

  def self.revenue
    service_fees = where("amount < ?", 0).sum(:amount) * -1
    site_revenue = where("owner_type = ?", "Admin").sum(:amount)
    (service_fees + site_revenue).to_f
  end

  private

  def set_txn_id
    loop do
      self.txn_id = SecureRandom.hex(5).upcase
      break unless self.class.exists?(txn_id: txn_id)
    end
  end

  def set_before_balance
    self.balance_before = self.owner.balance
  end

  def update_owner_balance
    new_balance = self.owner.balance + self.amount
    self.owner.update(balance: new_balance)
    self.update(:balance_after => new_balance)
  end
end
