class AddReferencesToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :construction_report, foreign_key: true
  end
end
