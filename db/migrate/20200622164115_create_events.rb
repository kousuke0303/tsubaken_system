class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :kind
      t.datetime :holded_on
      t.string :note
      t.references :manager, foreign_key: true
      t.references :matter, foreign_key: true

      t.timestamps
    end
  end
end
