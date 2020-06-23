class CreateAttendances < ActiveRecord::Migration[5.1]
  def change
    create_table :attendances do |t|
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
