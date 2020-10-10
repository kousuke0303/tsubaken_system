class CreateDepartments < ActiveRecord::Migration[5.1]
  def change
    create_table :departments do |t|
      t.string :name, null: false, default: "無所属"
      t.timestamps
    end
  end
end
