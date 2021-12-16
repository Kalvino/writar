class AddRolesToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :role, :integer, default: 0, null: false
    remove_column :admins, :super_admin, :boolean
  end
end
