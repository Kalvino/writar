class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :content
      t.references :order, index: true
      t.references :user, polymorphic: true, index: true

      t.timestamps
    end
  end
end
