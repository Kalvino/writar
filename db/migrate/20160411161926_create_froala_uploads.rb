class CreateFroalaUploads < ActiveRecord::Migration
  def change
    create_table :froala_uploads do |t|
      t.string :name
      t.integer :file_size
      t.string :url

      t.timestamps
    end
  end
end
