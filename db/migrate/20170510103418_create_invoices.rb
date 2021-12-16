class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.float :amount
      t.text :message

      t.string :first_name
      t.string :last_name
      t.string :payer_email
      t.string :payer_id
      t.string :txn_id
      t.string :residence_country
      t.string :payment_status, default: "pending"
      t.datetime :payment_date
      t.string :payment_token
      t.float :mc_fee
      t.float :mc_gross
      t.string :verify_sign
      t.references :order, index: true

      t.timestamps
    end
  end
end
