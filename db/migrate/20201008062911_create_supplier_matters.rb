class CreateSupplierMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :supplier_matters do |t|
      t.references :matter, foreign_key: true
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
