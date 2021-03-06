class DeviseCreateWriters < ActiveRecord::Migration
  def change
    create_table(:writers) do |t|
      ## Custom Fields
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :slug
      t.integer :orders_count, default: 0, null: false
      t.float :rate_per_page, default: 4, null: false
      t.decimal :balance, default: 0, null: false

      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :writers, :email,                unique: true
    add_index :writers, :slug,                 unique: true
    add_index :writers, :reset_password_token, unique: true
    # add_index :writers, :confirmation_token,   unique: true
    # add_index :writers, :unlock_token,         unique: true
  end
end
