class AddDocumentFingerprintToEssays < ActiveRecord::Migration
  def change
    add_column :essays, :document_fingerprint, :string
    add_index :essays, :document_fingerprint, unique: true
  end
end
