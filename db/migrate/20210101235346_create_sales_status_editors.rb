class CreateSalesStatusEditors < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_status_editors do |t|
      # 担当者が削除された時のカラム
      t.string :member_name
      t.references :sales_status, foreign_key: true
      t.integer :member_code_id, foreign_key: true
      t.timestamps
    end
    add_index  :sales_status_editors, :member_code_id
  end
end
