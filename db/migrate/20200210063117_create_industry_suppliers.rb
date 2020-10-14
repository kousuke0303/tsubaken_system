class CreateIndustrySuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :industry_suppliers do |t|
      t.references :industry, foreign_key: true
      t.references :supplier, foreign_key: true

      t.timestamps
    end
  end
end
