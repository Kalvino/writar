class AddUpdatedByToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :updated_by_id, :integer
    add_index :questions, :updated_by_id
  end
end
