class CreateInvoiceDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_details do |t|
      t.references :invoice, foreign_key: true
      t.integer :sort_number
      
      t.references :category, foreign_key: true
      t.string :category_name
      
      t.references :material, foreign_key: true
      t.string :material_name
      
      t.references :construction, foreign_key: true
      t.string :construction_name
      
      t.string :service_life
      t.string :note
      t.string :unit
      t.integer :price
      t.integer :amount
      t.integer :total

      t.timestamps
    end
  end
end
