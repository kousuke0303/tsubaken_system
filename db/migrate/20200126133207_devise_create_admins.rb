# frozen_string_literal: true

class DeviseCreateAdmins < ActiveRecord::Migration[5.1]
  def change
    create_table :admins do |t|
      t.string :auth,               null: false,default: "admin"
      t.string :name,               null: false
      t.string :email
      t.string :phone

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
