class CreateEstimateMatterStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_matter_staffs do |t|
      t.string :estimate_matter_id, null: false
      t.references :staff, foreign_key: true

      t.timestamps
    end
    add_foreign_key :estimate_matter_staffs, :estimate_matters
    add_index  :estimate_matter_staffs, :estimate_matter_id
  end
end
