class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :total_price
      t.integer :discount,             null: false, default: 0
      t.string :matter_id
      t.references :plan_name,         foreign_key: true

      t.timestamps
    end
    add_index :invoices, :matter_id
  end
end
