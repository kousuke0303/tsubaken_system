class CreateConstructionSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :construction_schedules do |t|
      t.string :title,         null: false, default: ""
      t.integer :status
      t.string :content
      t.date :scheduled_started_on, null: false
      t.date :scheduled_finished_on, null: false
      t.string :matter_id
      t.references :supplier, foreign_key: true
      t.timestamps
    end
    add_index  :construction_schedules, :matter_id
  end
end
