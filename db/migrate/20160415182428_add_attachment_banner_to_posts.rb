class AddAttachmentBannerToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :banner
    end
  end

  def self.down
    remove_attachment :posts, :banner
  end
end
