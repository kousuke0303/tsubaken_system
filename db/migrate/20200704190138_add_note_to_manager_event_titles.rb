class AddNoteToManagerEventTitles < ActiveRecord::Migration[5.1]
  def change
    add_column :manager_event_titles, :note, :string
  end
end
