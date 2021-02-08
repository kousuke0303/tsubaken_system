class CreateBandConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :band_connections do |t|
      t.string :estimate_matter_id
      t.string :band_key, null: false
      t.string :band_name, null: false
      t.string :band_icon
      t.timestamps
    end
    add_index  :band_connections, :estimate_matter_id
  end
end
