class Schedule < ApplicationRecord
  
  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :scheduled_end_time, presence: true
  validates :scheduled_start_time, presence: true
  validate :scheduled_end_time_is_after_start_time
  
  def scheduled_end_time_is_after_start_time
    if scheduled_start_time.present? && scheduled_end_time.present? && scheduled_start_time >= scheduled_end_time
      errors.add(:scheduled_end_time, "は開始予定時刻以降を入力してください") 
    end
  end
  
  
end
