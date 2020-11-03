class CreateStaffEventTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :staff_event_titles, id: :integer do |t|
      t.integer :staff_id, foreign_key: true
      t.integer :event_title_id, foreign_key: true

      t.timestamps
    end
  end
end