class CreateIndustries < ActiveRecord::Migration[5.1]
  def change
    create_table :industries do |t|
      t.string :name, null: false
      t.integer :position

      t.timestamps
    end
    add_index :industries, :name, unique: true
  end
end
