class CreateEstimateMatterMemberCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :estimate_matter_member_codes do |t|
      t.string :estimate_matter_id, null: false
      t.references :member_code
      
      t.timestamps
    end
    add_foreign_key :estimate_matter_member_codes, :estimate_matters
    add_index :estimate_matter_member_codes, :estimate_matter_id
  end
end
