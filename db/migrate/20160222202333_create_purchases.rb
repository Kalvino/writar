class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :first_name
      t.string :last_name
      t.string :payer_email
      t.string :payer_id
      t.string :txn_id
      t.string :residence_country
      t.string :payment_status
      t.datetime :payment_date
      t.string :payment_token
      t.float :mc_fee
      t.float :mc_gross
      t.string :verify_sign
      t.references :essay, index: true

      t.timestamps
    end
    add_index :purchases, :payment_token, unique: true
  end
end
