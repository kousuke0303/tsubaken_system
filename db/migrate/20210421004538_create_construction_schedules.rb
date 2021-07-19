class CreateConstructionSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :construction_schedules do |t|
      t.string :title,         null: false, default: ""
      t.integer :status
      t.text :content
      t.date :scheduled_started_on
      t.date :scheduled_finished_on
      t.date :started_on
      t.date :finished_on
      t.date :start_date
      t.date :end_date
      t.string :matter_id
      t.string :member_name
      t.boolean :report_count
      t.boolean :disclose,  null: false, default: true
      t.references :vendor, foreign_key: true
      t.references :member_code, foreign_key: true
      t.timestamps
    end
    add_index  :construction_schedules, :matter_id
  end
end
