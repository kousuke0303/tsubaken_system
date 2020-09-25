class CreateManagerEventTitles < ActiveRecord::Migration[5.1]
  def change
    create_table :manager_event_titles do |t|
      t.string :title
      t.string :note
      t.references :manager, foreign_key: true

      t.timestamps
    end
  end
end
