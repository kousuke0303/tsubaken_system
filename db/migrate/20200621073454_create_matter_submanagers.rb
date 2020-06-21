class CreateMatterSubmanagers < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_submanagers do |t|
      t.references :matter, index: true, foreign_key: true
      t.references :submanager, index: true, foreign_key: true
      t.timestamps
    end
  end
end
