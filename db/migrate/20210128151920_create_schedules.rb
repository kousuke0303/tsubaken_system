class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.date :scheduled_date, null: false
      t.time :scheduled_start_time, null: false
      t.time :scheduled_end_time, null: false
      t.string :title, null: false
      t.string :place
      t.text :note
      t.references :staff
      t.references :manager
      t.references :admin
      t.references :external_staff
      t.timestamps
    end
  end
end
