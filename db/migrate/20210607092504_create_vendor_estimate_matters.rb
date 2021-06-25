class CreateVendorEstimateMatters < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_estimate_matters do |t|
      t.string :estimate_matter_id, null: false
      t.references :vendor, foreign_key: true
      t.timestamps
    end
    add_foreign_key :vendor_estimate_matters, :estimate_matters
    add_index  :vendor_estimate_matters, :estimate_matter_id
  end
end
