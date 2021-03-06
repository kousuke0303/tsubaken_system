class CreateEstimateMatters < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_matters, id: :string do |t|
      t.string :title,                      null: false
      t.string :postal_code
      t.string :prefecture_code
      t.string :address_city
      t.string :address_street
      t.string :content
      t.bigint :supplier_id
      t.references :client, foreign_key: true
      t.references :attract_method, foreign_key: true
      t.references :publisher, foreign_key: true

      t.timestamps
    end
    add_foreign_key :estimate_matters, :vendors, column: :supplier_id
  end
end
