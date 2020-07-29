class CreateManagerStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :manager_staffs do |t|
      t.integer :employee, default: 0
      t.references :manager, index: true, foreign_key: true
      t.references :staff, index: true, foreign_key: true

      t.timestamps
    end
  end
end
