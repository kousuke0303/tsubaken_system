class CreateMatterUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :matter_users do |t|
      t.references :matter, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
