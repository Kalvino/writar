class CreateRedemptions < ActiveRecord::Migration
  def change
    create_table :redemptions do |t|
      t.references :coupon, index: true
      t.references :student, index: true
      t.references :order, index: true
      t.string :description

      t.timestamps
    end
  end
end
