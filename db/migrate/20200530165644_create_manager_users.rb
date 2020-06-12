class CreateManagerUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :manager_users do |t|
      t.references :user, index: true, foreign_key: true
      t.references :manager, index: true, foreign_key: true

      t.timestamps
    end
  end
end
