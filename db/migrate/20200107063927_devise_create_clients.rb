# frozen_string_literal: true

class DeviseCreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name,               null: false, default: ""
      t.string :kana
      t.integer :gender
      t.string :phone_1
      t.string :phone_2
      t.string :fax
      t.string :email
      t.date :birthed_on
      t.string :zip_code
      t.string :address

      ## Database authenticatable
      t.string :login_id,           null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :clients, :login_id, unique: true
  end
end
