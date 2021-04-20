# frozen_string_literal: true

class DeviseCreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :auth,               null: false, default: "client"
      t.string :name,               null: false
      t.boolean :avaliable,         null: false, default: false
      t.string :kana
      t.integer :gender
      t.string :phone_1
      t.string :phone_2
      t.string :fax
      t.string :email
      t.date :birthed_on
      t.string :postal_code
      t.string :prefecture_code
      t.string :address_city
      t.string :address_street
      t.string :tmp_password

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
