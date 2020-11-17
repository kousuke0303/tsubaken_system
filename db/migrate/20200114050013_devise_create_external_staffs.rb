# frozen_string_literal: true

class DeviseCreateExternalStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :external_staffs do |t|
      t.string :auth,               null: false, default: "external_staff"
      t.string :name,               null: false, default: ""
      t.string :kana
      t.string :phone
      t.string :email
      t.references :supplier,       foreign_key: true

      ## Database authenticatable
      t.string :login_id,           null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :external_staffs, :login_id,     unique: true
  end
end
