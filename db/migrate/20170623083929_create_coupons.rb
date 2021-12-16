class CreateCoupons < ActiveRecord::Migration
  def change
    create_table :coupons do |t|
      t.string :code
      t.string :description
      t.float :amount
      t.integer :redemption_limit, default: 1
      t.string :coupon_type, default: "percentage"
      t.datetime :valid_from
      t.datetime :valid_until

      t.timestamps
    end
    add_index :coupons, :code, unique: true
  end
end
