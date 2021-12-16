class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.text :meta_description
      t.string :slug

      t.timestamps
    end
    add_index :posts, :slug, unique: true
  end
end
