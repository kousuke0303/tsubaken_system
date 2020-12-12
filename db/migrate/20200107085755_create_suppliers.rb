class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :kana
      t.string :postal_code
      t.string :prefecture_code
      t.string :address_city 
      t.string :address_street
      t.string :representative
      t.string :phone_1
      t.string :phone_2
      t.string :fax
      t.string :email

      t.timestamps
    end
  end
end
