class CreateEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :estimates do |t|
      t.string :title,                 null: false
      t.integer :total_price,          null: false, default: 0   
      t.string :estimate_matter_id
      t.references :plan_name,         foreign_key: true
      t.timestamps
    end
    add_index  :estimates, :estimate_matter_id
  end
end
