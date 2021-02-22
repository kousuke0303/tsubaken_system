class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.integer :position
      t.timestamps
    end
  end
end
