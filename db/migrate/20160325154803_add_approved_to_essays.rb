class AddApprovedToEssays < ActiveRecord::Migration
  def change
    add_column :essays, :approved, :boolean, default: false
  end
end
