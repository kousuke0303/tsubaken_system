class CreateMatterStaffs < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_staffs do |t|
      t.string :matter_id, null: false
      t.references :staff, foreign_key: true

      t.timestamps
    end
    add_foreign_key :matter_staffs, :matters
    add_index  :matter_staffs, :matter_id
  end
end
