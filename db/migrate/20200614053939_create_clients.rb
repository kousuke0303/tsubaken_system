class CreateClients < ActiveRecord::Migration[5.1]
  def change
    create_table :clients do |t|
      t.string :name, comment: "名前"
      t.string :phone, comment: "連絡先"
      t.string :fax, comment: "FAX"
      t.string :email, comment: "email"
      t.references :matter, index: true, foreign_key: true
      
      t.timestamps
    end
  end
end
