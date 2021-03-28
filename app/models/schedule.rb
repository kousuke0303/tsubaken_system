class Schedule < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true
  belongs_to :sales_status, optional: true
  belongs_to :member_code
  
  has_one :notification, dependent: :destroy
  
  # 変更申請用
  has_many :applications, class_name: "Schedule", foreign_key: "schedule_id"
  belongs_to :original, class_name: "Schedule", foreign_key: "schedule_id", optional: true
  
  before_save :member_name_update
  
  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :scheduled_end_time, presence: true
  validates :scheduled_start_time, presence: true
  
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :create
  validate :except_duplicate_schedule_for_update, on: :update
  
  scope :origins, -> { where(schedule_id: nil)}
  scope :edit_applications, -> { where.not(schedule_id: nil)}
  
  
  def notification(reciever_code)
    self.create_notification(status: 0, category: 1, sender_id: sender_code)
  end

  private
  
  #----------------------------------------------
    #VALIDATION_METHOD
  #---------------------------------------------
    
    def scheduled_end_time_is_after_start_time
      if scheduled_start_time.present? && scheduled_end_time.present? && scheduled_start_time >= scheduled_end_time
        errors.add(:scheduled_end_time, "は開始予定時刻以降を入力してください") 
      end
    end
    
    # 重複スケジュール登録拒否
    def except_duplicate_schedule
      duplicate_schedule = Schedule.where(member_code_id: self.member_code_id, scheduled_date: self.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', self.scheduled_start_time, self.scheduled_end_time)
      if duplicate_schedule.present?
        errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
      end
    end
    
    
    # 重複スケジュール登録拒否
    # DBに保存されている時間はUTCのため、文字列に変換した上で比較
    def except_duplicate_schedule_for_update
      designated_schedules = Schedule.where.not(id: self.id).where(member_code_id: self.member_code_id, scheduled_date: self.scheduled_date)
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
    
    #-----------------------------------------------------
      # CALLBACK_METHOD
    #-----------------------------------------------------
    
    def member_name_update
      member_code = MemberCode.find(self.member_code_id)
      self.member_name = member_code.member_name_from_member_code
    end
end
