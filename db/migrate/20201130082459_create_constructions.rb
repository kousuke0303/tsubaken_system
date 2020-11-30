class CreateConstructions < ActiveRecord::Migration[5.2]
  def change
    create_table :constructions do |t|
      t.string :name
      t.string :note
      t.string :unit
      t.integer :price

      t.timestamps
    end
  end
end
