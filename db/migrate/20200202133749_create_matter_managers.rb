class CreateMatterManagers < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_managers do |t|
      t.references :matter, foreign_key: true
      t.references :manager, foreign_key: true

      t.timestamps
    end
  end
end
