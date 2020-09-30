class CreateMatters < ActiveRecord::Migration[5.1]
  def change
    create_table :matters do |t|
      t.string :title
      t.string :actual_spot_1, comment: "現場住所1"
      t.string :actual_spot_2, commit: "現場住所２"
      t.string :zip
      t.string :status, default: false, comment: "工事状況"
      t.string :note
      t.date :scheduled_started_on, comment: "着工予定日"
      t.date :started_on, comment: "着工日"
      t.date :scheduled_finished_on, comment: "完了予定日"
      t.date :finished_on, comment: "完了日"
      t.string :matter_uid, comment: "パラメーター"
      t.string :connected_id, comment: "パラメーター"

      t.timestamps
    end
  end
end
