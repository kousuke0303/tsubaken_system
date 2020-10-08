class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :address
      t.string :zip_code
      t.string :representative
      t.string :phone_1
      t.string :phone_2
      t.string :fax
      t.string :email

      t.timestamps
    end
  end
end
