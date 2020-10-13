# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :name,               null: false, default: ""

      ## Database authenticatable
      t.string :login_id,           null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :admins, :login_id,          unique: true
  end
end
