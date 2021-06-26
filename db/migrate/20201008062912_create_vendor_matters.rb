class CreateVendorMatters < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_matters do |t|
      t.string :matter_id, null: false
      t.references :vendor, foreign_key: true

      t.timestamps
    end
    add_foreign_key :vendor_matters, :matters
    add_index  :vendor_matters, :matter_id
  end
end
