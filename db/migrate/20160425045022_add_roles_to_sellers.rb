class AddRolesToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :role, :integer, default: 0, null: false
  end
end
