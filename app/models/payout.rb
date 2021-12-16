class Payout < ActiveRecord::Base
  belongs_to :user, polymorphic: true

  after_create :update_writer_balance

  private

  def update_writer_balance
    user.transactions.create(txn_type: "Payout", amount: self.amount*-1, description: "Payout of $#{amount}")
  end
end
