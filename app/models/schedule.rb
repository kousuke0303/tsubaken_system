class Schedule < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true
  belongs_to :sales_status, optional: true
  
  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :scheduled_end_time, presence: true
  validates :scheduled_start_time, presence: true
  
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :create
  validate :except_duplicate_schedule_for_update, on: :update
  
  private
  
  #----------------------------------------------
    #Validation_Method
  #---------------------------------------------
    
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
    # DBに保存されている時間はUTCのため、文字列に変換した上で比較
    def except_duplicate_schedule_for_update
      if admin_id.present?
        designated_schedules = Schedule.where.not(id: self.id).where(admin_id: self.admin_id, scheduled_date: self.scheduled_date)
      elsif manager_id.present?
        designated_schedules = Schedule.where.not(id: self.id).where(manager_id: self.manager_id, scheduled_date: self.scheduled_date)
      elsif staff_id.present?
        designated_schedules = Schedule.where.not(id: self.id).where(staff_id: self.staff_id, scheduled_date: self.scheduled_date)
      elsif external_staff_id.present?
        designated_schedules = Schedule.where.not(id: self.id).where(external_staff_id: self.external_staff_id, scheduled_date: self.scheduled_date)
      end
      if designated_schedules.present?
        designated_schedules.each do |schedule|
          start_time = schedule.scheduled_start_time.to_s(:time)
          end_time = schedule.scheduled_end_time.to_s(:time)
          params_start_time = self.scheduled_start_time.to_s(:time)
          params_end_time = self.scheduled_end_time.to_s(:time)
          if end_time > params_start_time && params_end_time > start_time
            errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
          end
        end
      end
    end
end
