class CreateSalesStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_statuses do |t|
      t.integer :status,                null: false
      t.date :conducted_on,             null: false
      t.string :note
      t.references :staff,              foreign_key: true
      t.references :external_staff,     foreign_key: true
      t.string :estimate_matter_id   

      t.timestamps
    end
    add_index  :sales_statuses, :estimate_matter_id
  end
end
