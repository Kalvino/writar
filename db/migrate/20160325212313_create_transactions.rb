class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.string :txn_type
      t.string :txn_id, index: true, unique: true
      t.decimal :amount
      t.decimal :balance_before
      t.decimal :balance_after
      t.text :description
      t.integer :owner_id
      t.string :owner_type
      t.references :purchase, index: true

      t.timestamps
    end
  end
end
