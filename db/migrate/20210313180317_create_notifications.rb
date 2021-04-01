class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :status, null: false, default: 0
      t.integer :category
      t.integer :action_type
      t.integer :sender_id
      t.integer :reciever_id
      t.string :before_value_1
      t.string :before_value_2
      t.string :before_value_3
      t.string :before_value_4
      t.text :content
      
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
