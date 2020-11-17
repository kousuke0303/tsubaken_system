class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :working_minutes
      t.references :manager,          foreign_key: true
      t.references :staff,            foreign_key: true
      t.references :external_staff,   foreign_key: true

      t.timestamps
    end
  end
end
