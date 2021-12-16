class CreateThumbnails < ActiveRecord::Migration
  def change
    create_table :thumbnails do |t|
      t.references :essay, index: true

      t.timestamps
    end
  end
end
