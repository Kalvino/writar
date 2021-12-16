class FixUserIdOnWithdrawals < ActiveRecord::Migration
  def change
    rename_column :withdrawals, :user_id, :seller_id
  end
end
