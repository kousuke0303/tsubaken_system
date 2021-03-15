class CreateAdoptedEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :adopted_estimates do |t|
      t.integer :total_price,          null: false, default: 0
      t.integer :discount,             null: false, default: 0
      t.string :matter_id
      t.references :plan_name,         foreign_key: true

      t.timestamps
    end
    add_index :adopted_estimates, :matter_id
  end
end
