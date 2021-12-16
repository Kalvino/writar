class AddTimeZoneToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :timezone, :string, default: "Nairobi"
  end
end
