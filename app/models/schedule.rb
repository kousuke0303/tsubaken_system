class Schedule < ApplicationRecord
  
  after_commit :create_notification, on: :create
  after_commit :update_notification, on: :update
  after_destroy :destroy_notification
  before_save :member_name_update
  
  belongs_to :sales_status, optional: true
  belongs_to :member_code
  
  has_many :notifications, dependent: :destroy
  
  # 変更申請用
  has_many :applications, class_name: "Schedule", foreign_key: "schedule_id"
  belongs_to :original, class_name: "Schedule", foreign_key: "schedule_id", optional: true
  
  validates :title, presence: true
  validates :scheduled_date, presence: true
  validates :scheduled_end_time, presence: true
  validates :scheduled_start_time, presence: true
  
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :create
  validate :except_duplicate_schedule_for_update, on: :update
  
  scope :origins, -> { where(schedule_id: nil)}
  scope :edit_applications, -> { where.not(schedule_id: nil)}
  
  # notification用変数
  attr_accessor :sender #member_code_id
  attr_accessor :before_member_code
  attr_accessor :before_scheduled_date
  attr_accessor :before_scheduled_start_time
  attr_accessor :before_scheduled_end_time
  attr_accessor :before_title
  
  def member
    if self.sales_status_id.present?
      sales_status = SalesStatus.find(self.sales_status_id)
      return sales_status.estimate_matter.member
    else
      MemberCode.all_member_for_select_form
    end
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
    
    def create_notification
      Notification.create(category: 1, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id, schedule_id: self.id)
    end
    
    def update_notification
      if self.before_member_code.present?
        Notification.create(category: 1, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id, schedule_id: self.id)
        Notification.create(category: 1, action_type: 2, sender_id: self.sender, reciever_id: self.before_member_code, schedule_id: self.id,
                            before_value_1: self.before_scheduled_date, before_value_2: self.scheduled_start_time,
                            before_value_3: self.before_scheduled_end_time, before_value_4: self.before_title)
      elsif self.before_scheduled_date != nil || self.before_scheduled_start_time != nil || self.before_scheduled_end_time != nil
        Notification.create(category: 1, action_type: 1, sender_id: self.sender, reciever_id: self.member_code_id, schedule_id: self.id,
                            before_value_1: self.before_scheduled_date, before_value_2: self.scheduled_start_time,
                            before_value_3: self.before_scheduled_end_time)
      end
    end
    
    def destroy_notification
      Notification.create(category: 1, action_type: 2, sender_id: self.sender, reciever_id: self.member_code_id,
                          before_value_1: self.scheduled_date, before_value_2: self.scheduled_start_time,
                          before_value_3: self.scheduled_end_time, before_value_4: self.title)
    end
      
end
