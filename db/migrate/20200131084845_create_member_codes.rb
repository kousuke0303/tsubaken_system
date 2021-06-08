class CreateMemberCodes < ActiveRecord::Migration[5.2]
  def change
    create_table :member_codes do |t|
      t.references :staff, foreign_key: true
      t.references :manager, foreign_key: true
      t.references :admin, foreign_key: true
      t.references :external_staff, foreign_key: true
      t.references :client, foreign_key: true
      t.timestamps
    end
  end
end
