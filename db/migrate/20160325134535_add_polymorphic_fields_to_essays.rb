class AddPolymorphicFieldsToEssays < ActiveRecord::Migration
  def change
    add_column :essays, :owner_id, :integer
    add_column :essays, :owner_type, :string
  end
end
