class AddAttachmentDocumentToEssays < ActiveRecord::Migration
  def self.up
    change_table :essays do |t|
      t.attachment :document
    end
  end

  def self.down
    remove_attachment :essays, :document
  end
end
