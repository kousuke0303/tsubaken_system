class CreateSalesStatuses < ActiveRecord::Migration[5.2]
  def change
    create_table :sales_statuses do |t|
      t.integer :status,                null: false
      t.date :scheduled_date,           null: false
      t.string :note
      t.string :estimate_matter_id
      t.time :scheduled_start_time
      t.time :scheduled_end_time
      t.string :place
      t.integer :register_for_schedule, null: false, default: 0
      t.integer :member_code_id, foreign_key: true
      # 担当者が削除された時のカラム
      t.string :member_name
      t.timestamps
    end
    add_index  :sales_statuses, :estimate_matter_id
    add_index  :sales_statuses, :member_code_id
  end
end
