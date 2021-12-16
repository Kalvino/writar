class AddBalanceToUsers < ActiveRecord::Migration
  def change
    add_column :sellers, :balance, :decimal, default: 0.00
  end
end
