class CreateConstructionSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :construction_schedules do |t|
      t.string :title,         null: false, default: ""
      t.integer :status
      t.string :content
      t.date :scheduled_started_on
      t.date :scheduled_finished_on
      t.date :started_on
      t.date :finished_on
      t.string :matter_id
      t.boolean :disclose,  null: false, default: true
      t.references :supplier, foreign_key: true
      t.timestamps
    end
    add_index  :construction_schedules, :matter_id
  end
end
