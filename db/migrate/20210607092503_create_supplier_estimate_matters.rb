class CreateSupplierEstimateMatters < ActiveRecord::Migration[5.2]
  def change
    create_table :supplier_estimate_matters do |t|
      t.string :estimate_matter_id, null: false
      t.references :supplier, foreign_key: true
      t.timestamps
    end
    add_foreign_key :supplier_estimate_matters, :estimate_matters
    add_index  :supplier_estimate_matters, :estimate_matter_id
  end
end
