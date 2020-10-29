class CreateMatterManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_managers do |t|
      t.string :matter_id, null: false
      t.references :manager, foreign_key: true

      t.timestamps
    end
    add_foreign_key :matter_managers, :matters
    add_index  :matter_managers, :matter_id
  end
end
