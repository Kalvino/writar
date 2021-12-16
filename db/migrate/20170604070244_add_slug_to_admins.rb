class AddSlugToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :slug, :string
    add_index :admins, :slug, unique: true
  end
end
