class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :first_name
      t.string :last_name
      t.string :subject
      t.string :address
      t.text :message

      t.timestamps
    end
  end
end
