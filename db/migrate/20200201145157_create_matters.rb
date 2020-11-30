class CreateMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :matters, id: :string do |t|
      t.string :title,                      null: false, default: ""
      t.string :actual_spot
      t.string :zip_code
      t.integer :status
      t.string :content
      t.date :scheduled_started_on
      t.date :started_on
      t.date :scheduled_finished_on
      t.date :finished_on
      t.date :maintenanced_on
      t.string :estimate_matter_id

      t.timestamps
    end
    add_foreign_key :matters, :estimate_matters
    add_index  :matters, :estimate_matter_id
  end
end
