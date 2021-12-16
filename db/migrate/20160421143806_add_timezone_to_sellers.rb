class AddTimezoneToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :timezone, :string, default: "UTC"
  end
end
