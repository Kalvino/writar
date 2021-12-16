class RenameApproved < ActiveRecord::Migration
  def change
    remove_column :essays, :approved
    add_column :essays, :status, :integer, default: 0, null: false
  end
end
