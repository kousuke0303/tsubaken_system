class CreateUserDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :user_devices do |t|
      t.text :instance_id, null: false
      t.string :platform
      t.references :member_code, foreign_key: true
      t.timestamps
    end
  end
end
