class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :name, comment: "会社名"
      t.string :address, comment: "所在地"
      t.string :address_2, comment: "所在地2"
      t.string :zip
      t.string :representative, comment: "代表者名"
      t.string :phone, comment: "電話番号"
      t.string :fax, comment: "FAX番号"
      t.string :email, comment: "メール"

      t.timestamps
    end
  end
end
