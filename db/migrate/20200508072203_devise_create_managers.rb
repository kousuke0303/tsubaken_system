# frozen_string_literal: true

class DeviseCreateManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :managers do |t|
      t.string :name, null: false
      t.string :phone
      t.string :company
      t.string :email

      ## Database authenticatable
      t.string :employee_id, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      t.timestamps null: false
    end

    add_index :managers, :employee_id,          unique: true
    add_index :managers, :email,                unique: true
    add_index :managers, :reset_password_token, unique: true
  end
end
