class AddSlugToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :slug, :string
    add_index :purchases, :slug, unique: true
  end
end
