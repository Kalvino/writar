class AddBalanceToAdmin < ActiveRecord::Migration
  def change
    add_column :admins, :balance, :decimal, default: 0.0
  end
end
