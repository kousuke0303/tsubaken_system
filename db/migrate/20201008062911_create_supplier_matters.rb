class CreateSupplierMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_matters do |t|
      t.string :matter_id, null: false
      t.references :supplier, foreign_key: true

      t.timestamps
    end
    add_foreign_key :supplier_matters, :matters
    add_index  :supplier_matters, :matter_id
  end
end
