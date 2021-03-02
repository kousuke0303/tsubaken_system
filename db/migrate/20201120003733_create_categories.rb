class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name,            null: false
      t.integer :position
      t.references :estimate,    foreign_key: true
      t.integer :classification,  null: false, default: 0

      t.timestamps
    end
  end
end
