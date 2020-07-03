class CreateMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :matters do |t|
      t.string :title, comment: "事件名"
      t.string :actual_spot, comment: "現場"
      t.string :status, default: false, comment: "工事状況"
      t.string :note, comment: "備考"
      t.date :scheduled_start_at, comment: "着工予定日"
      t.date :started_at, comment: "着工日"
      t.date :scheduled_finish_at, comment: "完了予定日"
      t.date :finished_at, comment: "完了日"
      t.string :matter_uid, comment: "パラメーター"
      t.string :connected_id, comment: "パラメーター"

      t.timestamps
    end
  end
end
