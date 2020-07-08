class CreateSubmanagerEventTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :submanager_event_titles do |t|
      t.string :event_name
      t.string :note
      t.references :submanager, foreign_key: true

      t.timestamps
    end
  end
end
