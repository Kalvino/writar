class AddCounterCacheToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :essays_count, :integer, default: 0
    Admin.find_each { |admin| Admin.reset_counters(admin.id, :essays) }
  end
end
