class CreateStaffEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :staff_events do |t|
      t.string :title
      t.string :kind
      t.datetime :holded_on
      t.string :note
      t.references :staff, foreign_key: true

      t.timestamps
    end
  end
end
