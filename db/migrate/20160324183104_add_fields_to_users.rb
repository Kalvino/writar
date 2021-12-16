class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :sellers, :first_name, :string
    add_column :sellers, :last_name, :string
    add_column :sellers, :username, :string
    add_index :sellers, :username, unique: true
  end
end
