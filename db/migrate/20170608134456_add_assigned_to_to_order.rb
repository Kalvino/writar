class AddAssignedToToOrder < ActiveRecord::Migration
  def change
    add_reference :orders, :assigned_to, index: true
  end
end
