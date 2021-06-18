class CreateConstructionReports < ActiveRecord::Migration[5.2]
  def change
    create_table :construction_reports do |t|
      t.date :work_date, null: false
      t.datetime :start_time
      t.datetime :end_time
      t.integer :report, default: 0
      t.integer :reason, default: 0
      t.text :memo
      t.boolean :admin_check, default: false
      t.boolean :sm_check, default: false
      t.references :construction_schedule, foreign_key: true
      t.timestamps
    end
  end
end
