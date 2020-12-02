class CreateEstimateMatters < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_matters, id: :string do |t|
      t.string :title,                      null: false, default: ""      
      t.string :zip_code
      t.string :address
      t.string :content
      t.integer :status,                    null: false, default: 0
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
