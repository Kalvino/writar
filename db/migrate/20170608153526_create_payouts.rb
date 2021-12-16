class CreatePayouts < ActiveRecord::Migration
  def change
    create_table :payouts do |t|
      t.decimal :amount
      t.references :user, polymorphic: true, index: true

      t.timestamps
    end
  end
end
