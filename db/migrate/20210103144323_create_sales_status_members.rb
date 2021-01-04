class CreateSalesStatusMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_status_members do |t|
      t.string :authority
      t.integer :member_id
      t.references :sales_status, foreign_key: true
      t.timestamps
    end
  end
end
