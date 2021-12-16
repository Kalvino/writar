class AddSlugToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :slug, :string
    add_index :transactions, :slug, unique: true
  end
end
