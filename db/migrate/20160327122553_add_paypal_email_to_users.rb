class AddPaypalEmailToUsers < ActiveRecord::Migration
  def change
    add_column :sellers, :paypal_email, :string
    add_index :sellers, :paypal_email, unique: true
  end
end
