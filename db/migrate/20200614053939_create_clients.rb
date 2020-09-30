class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :phone
      t.string :fax
      t.string :email
      t.references :matter, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
