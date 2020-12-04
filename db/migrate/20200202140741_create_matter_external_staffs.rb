class CreateMatterExternalStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :matter_external_staffs do |t|
      t.string :matter_id, null: false
      t.references :external_staff, foreign_key: true

      t.timestamps
    end
    add_foreign_key :matter_external_staffs, :matters
    add_index  :matter_external_staffs, :matter_id
  end
end
