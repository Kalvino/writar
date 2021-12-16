class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :title
      t.text :content
      t.string :slug
      t.text :retrieved_from
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :questions, :slug, unique: true
    add_index :questions, :retrieved_from, unique: true
  end
end
