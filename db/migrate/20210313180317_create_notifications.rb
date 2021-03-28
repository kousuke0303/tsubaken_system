class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :status
      t.integer :category
      t.text :content
      t.integer :sender_id
      t.integer :reciever_id
      
      t.references :schedule, foreign_key: true

      t.timestamps
    end
  end
end
