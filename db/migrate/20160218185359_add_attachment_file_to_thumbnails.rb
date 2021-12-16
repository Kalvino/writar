class AddAttachmentFileToThumbnails < ActiveRecord::Migration
  def self.up
    change_table :thumbnails do |t|
      t.attachment :file
    end
  end

  def self.down
    remove_attachment :thumbnails, :file
  end
end
