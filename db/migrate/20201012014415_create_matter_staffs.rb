class CreateMatterStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_staffs do |t|
      t.references :matter, index: true, foreign_key: true
      t.references :staff, index: true, foreign_key: true
      t.timestamps
    end
  end
end
