class CreateMaterials < ActiveRecord::Migration[5.2]
  def change
    create_table :materials do |t|
      t.string :name,            null: false
      t.string :service_life
      t.string :note
      t.string :unit
      t.integer :price
      t.integer :amount
      t.string :total
      t.references :plan_name,    foreign_key: true

      t.timestamps
    end
  end
end
