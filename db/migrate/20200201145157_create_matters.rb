class CreateMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :matters do |t|
      t.string :title
      t.string :actual_spot
      t.string :zip_code
      t.string :status
      t.string :content
      t.date :scheduled_started_on
      t.date :started_on
      t.date :scheduled_finished_on
      t.date :finished_on
      t.date :maintenanced_on
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
