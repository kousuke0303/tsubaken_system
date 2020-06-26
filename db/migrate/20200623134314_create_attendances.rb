class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.datetime :started_at
      t.datetime :finished_at
      t.references :submanager, foreign_key: true
      t.references :staff, foreign_key: true
      t.timestamps
    end
  end
end
