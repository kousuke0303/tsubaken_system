# frozen_string_literal: true

class DeviseCreateStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :staffs do |t|
      t.string :name,               null: false, default: ""
      t.string :phone
      t.string :email
      t.date :birthed_on
      t.string :zip_code
      t.string :address
      t.date :joined_on
      t.date :resigned_on
      t.references :department, foreign_key: true

      ## Database authenticatable
      t.string :login_id,        null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      ## Rememberable
      t.datetime :remember_created_at
      t.timestamps null: false
    end
    add_index :staffs, :login_id,          unique: true
  end
end
