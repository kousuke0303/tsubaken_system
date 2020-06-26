class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :event_name
      t.string :event_type
      t.datetime :date
      t.string :note
      t.references :manager, foreign_key: true, foreign_key: true
      t.references :matter, foreign_key: true, foreign_key: true

      t.timestamps
    end
  end
end
