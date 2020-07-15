class CreateStaffEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :staff_events do |t|
      t.string :event_name
      t.string :event_type
      t.datetime :date
      t.string :note
      t.references :staff, foreign_key: true

      t.timestamps
    end
  end
end
