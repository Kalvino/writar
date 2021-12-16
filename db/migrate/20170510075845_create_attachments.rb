class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :attachable, :polymorphic => true
      t.integer :downloads, default: 0
      t.timestamps
    end
  end
end
