class CreateWithdrawals < ActiveRecord::Migration
  def change
    create_table :withdrawals do |t|
      t.decimal :amount
      t.references :user, index: true

      t.timestamps
    end
  end
end
