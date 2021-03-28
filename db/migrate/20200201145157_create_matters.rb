class CreateMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :matters, id: :string do |t|
      t.string :title,                      null: false, default: ""
      t.string :postal_code
      t.string :prefecture_code
      t.string :address_city
      t.string :address_street
      t.string :content
      t.date :scheduled_started_on
      t.date :started_on
      t.date :scheduled_finished_on
      t.date :finished_on
      t.integer :status,                    null: false, default: 0
      t.date :maintenanced_on
      t.string :estimate_matter_id
      t.references :estimate, foreign_key: true
      t.references :publisher, foreign_key: true
      t.references :client, foreign_key: true
      t.references :attract_method, foreign_key: true
      t.timestamps
    end
    add_foreign_key :matters, :estimate_matters
    add_index  :matters, :estimate_matter_id
  end
end
