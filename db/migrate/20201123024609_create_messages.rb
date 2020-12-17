class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :message
      t.integer :admin_id
      t.integer :manager_id
      t.integer :staff_id
      t.integer :external_staff_id
      t.string :matter_id
      t.timestamps
    end
    add_foreign_key :messages, :matters
    add_index :messages, :matter_id
  end
end
