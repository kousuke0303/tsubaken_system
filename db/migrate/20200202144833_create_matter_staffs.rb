class CreateMatterStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_staffs do |t|
      t.references :matter, foreign_key: true
      t.references :staff, foreign_key: true

      t.timestamps
    end
  end
end
