class CreateReferencingStyles < ActiveRecord::Migration
  def change
    create_table :referencing_styles do |t|
      t.string :name

      t.timestamps
    end
    add_index :referencing_styles, :name, unique: true
  end
end
