class CreateSubmanagersAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :submanagers_attendances do |t|
      t.date :worked_on
      t.datetime :started_at
      t.datetime :finished_at
      t.string :note
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
      t.references :submanager, index: true, foreign_key: true
      t.references :matter, index: true, foreign_key: true
      t.timestamps
    end
  end
end
