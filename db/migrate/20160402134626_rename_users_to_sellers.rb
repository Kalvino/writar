class RenameUsersToSellers < ActiveRecord::Migration
  def change
    rename_table :users, :sellers
  end
end
