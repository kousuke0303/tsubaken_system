class CreateMatterMemberCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :matter_member_codes do |t|
      t.string :matter_id, null: false
      t.integer :member_code_id, foreign_key: true
      
      t.timestamps
    end
    add_foreign_key :matter_member_codes, :matters
    add_index :matter_member_codes, :matter_id
    add_index :matter_member_codes, :member_code_id
  end
end
