class CreateSalesStatusEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_status_editors do |t|
      t.string :authority
      t.integer :member_id
      # 担当者が削除された時のカラム
      t.string :member_name
      t.references :sales_status, foreign_key: true
      t.timestamps
    end
  end
end
