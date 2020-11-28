class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.integer :matter_id
      t.integer :admin_id
      t.integer :manager_id
      t.integer :staff_id
      t.integer :external_staff_id
      t.text :message
      t.string :picture
      t.timestamps
    end
  end
end
