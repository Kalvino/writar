class AddPageToThumbnail < ActiveRecord::Migration
  def change
    add_column :thumbnails, :page_no, :integer
  end
end
