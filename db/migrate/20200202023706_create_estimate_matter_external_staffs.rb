class CreateEstimateMatterExternalStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_matter_external_staffs do |t|
      t.string :estimate_matter_id, null: false
      t.references :external_staff, foreign_key: true

      t.timestamps
    end
    add_foreign_key :estimate_matter_external_staffs, :estimate_matters
    add_index  :estimate_matter_external_staffs, :estimate_matter_id
  end
end
