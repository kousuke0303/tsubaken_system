class CreateSuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers do |t|
      t.string :company, comment: "会社名"
      t.string :location, comment: "所在地"
      t.string :representative_name, comment: "代表者名"
      t.string :phone, comment: "電話番号"
      t.string :fax, comment: "FAX番号"
      t.string :mail, comment: "メール"
      t.integer :count, comment: "関連事件数"
      t.references :manager, foreign_key: true

      t.timestamps
    end
  end
end
