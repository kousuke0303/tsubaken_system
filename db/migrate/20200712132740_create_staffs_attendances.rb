class CreateStaffsAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :staffs_attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.integer :staff_id
      t.integer :matter_id
      t.references :staff, index: true, foreign_key: true
      t.references :matter, index: true, foreign_key: true
      t.timestamps
    end
  end
end
