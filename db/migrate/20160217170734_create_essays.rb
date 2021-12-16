class CreateEssays < ActiveRecord::Migration
  def change
    create_table :essays do |t|
      t.string :title
      t.float :price
      t.integer :page_count
      t.integer :word_count
      t.string :short_description
      t.text :question
      t.text :preview
      t.string :slug
      t.references :referencing_style, index: true
      t.references :category, index: true
      t.integer :download_count, default: 0

      t.timestamps
    end
    add_index :essays, :slug, unique: true
  end
end
