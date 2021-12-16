class AddSlugToUsers < ActiveRecord::Migration
  def change
    add_column :sellers, :slug, :string
    add_index :sellers, :slug, unique: true
  end
end
