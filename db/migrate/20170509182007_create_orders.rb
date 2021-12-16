class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :topic, default: "Writer's Choice"
      t.string :academic_level, default: "college"
      t.string :paper_type
      t.string :discipline
      t.string :citation_style, default: "MLA"
      t.integer :hours_to_deadline, default: 72
      t.datetime :due_at
      t.string :sources, default: "0"
      t.string :pages, default: "1"
      t.string :spacing, default: "double"
      t.text :instructions
      t.integer :status, default: 0, null: false
      t.string :uid, unique: true
      t.string :slug, unique: true
      t.references :student, index: true
      t.boolean :inquiry, default: false

      t.timestamps
    end
  end
end
