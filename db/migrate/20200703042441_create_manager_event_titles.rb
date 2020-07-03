class CreateManagerEventTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :manager_event_titles do |t|
      t.string :event_name
      t.references :manager, foreign_key: true

      t.timestamps
    end
  end
end
