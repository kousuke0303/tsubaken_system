class CreateEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :estimates do |t|
      t.string :title,                 null: false
      t.integer :total_price,          null: false, default: 0
      t.integer :discount,             null: false, default: 0 
      t.string :estimate_matter_id
      t.integer :position
      t.references :plan_name,         foreign_key: true
      t.string :matter_id
      t.timestamps
    end
    add_index :estimates, :estimate_matter_id
    add_index :estimates, :matter_id
  end
end
