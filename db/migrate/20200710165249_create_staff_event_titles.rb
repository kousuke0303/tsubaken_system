class CreateStaffEventTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :staff_event_titles do |t|
      t.string :title
      t.string :note
      t.references :staff, foreign_key: true

      t.timestamps
    end
  end
end
