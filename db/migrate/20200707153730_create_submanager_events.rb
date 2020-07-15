class CreateSubmanagerEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :submanager_events do |t|
      t.string :event_name
      t.string :event_type
      t.datetime :date
      t.string :note
      t.references :submanager, index: true, foreign_key: true

      t.timestamps
    end
  end
end
