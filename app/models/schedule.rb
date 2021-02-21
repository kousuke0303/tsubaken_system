class Schedule < ApplicationRecord
  
  has_one :admin
  has_one :manager
  has_one :staff
  has_one :external_staff
  
  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :scheduled_end_time, presence: true
  validates :scheduled_start_time, presence: true
  
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :create
  validate :except_duplicate_schedule_for_update, on: :update
  
  def scheduled_end_time_is_after_start_time
    if scheduled_start_time.present? && scheduled_end_time.present? && scheduled_start_time >= scheduled_end_time
      errors.add(:scheduled_end_time, "は開始予定時刻以降を入力してください") 
    end
  end
  
  # 重複スケジュール登録拒否
  def except_duplicate_schedule
    if admin_id.present?
      duplicate_schedule = Schedule.where(admin_id: self.admin_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif manager_id.present?
      duplicate_schedule = Schedule.where(manager_id: self.manager_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif staff_id.present?
      duplicate_schedule = Schedule.where(staff_id: self.staff_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif external_staff_id.present?
      duplicate_schedule = Schedule.where(external_staff_id: self.external_staff_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    end
    if duplicate_schedule.present?
      errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
    end
  end
  
  # 重複スケジュール登録拒否
  def except_duplicate_schedule_for_update
    if admin_id.present?
      duplicate_schedule = Schedule.where.not(id: self.id).where(admin_id: self.admin_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif manager_id.present?
      duplicate_schedule = Schedule.where.not(id: self.id).where(manager_id: self.manager_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif staff_id.present?
      duplicate_schedule = Schedule.where.not(id: self.id).where(staff_id: self.staff_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    elsif external_staff_id.present?
      duplicate_schedule = Schedule.where.not(id: self.id).where(external_staff_id: self.external_staff_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
    end
    if duplicate_schedule.present?
      errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
    end
  end
  
  
end
