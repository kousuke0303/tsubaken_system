class ConstructionSchedule < ApplicationRecord
  
  after_find :change_status
  after_find :set_started_on, :set_finished_on
  after_find :set_start_date
  after_find :set_end_date
  after_find :set_report_count
  after_commit :set_member_code, on: :update
  after_commit :create_notification, on: :create
  
  belongs_to :matter
  belongs_to :supplier, optional: true
  belongs_to :member_code, optional: true
  
  has_many :construction_schedule_materials, dependent: :destroy
  has_many :materials, through: :construction_schedule_materials
  has_many :construction_reports, dependent: :destroy
  has_many :construction_schedule_images, dependent: :destroy
  has_many :images, through: :construction_schedule_images
  
  validates :title, presence: true
  validate :finished_on_is_before_today
  validate :necessary_of_started_on
  
  with_options on: :normal_commit do |normal_commit|
    normal_commit.validates :scheduled_started_on, presence: true
    normal_commit.validates :scheduled_finished_on, presence: true
    normal_commit.validate :scheduled_finished_on_is_after_started_on
  end
  
  enum status: { not_started: 0, progress: 1, completed: 2 }
  
  scope :order_start_date, ->{ order(:start_date)}
  scope :today_work, -> { where('scheduled_finished_on >= ? and ? >= scheduled_started_on', Date.current, Date.current)}
  scope :before_yesterday_work, -> { where('? >= scheduled_started_on', Date.current.yesterday)}
  
  # notification用変数
  attr_accessor :sender #member_code_id
  attr_accessor :before_member_code
  attr_accessor :before_scheduled_date
  attr_accessor :before_scheduled_start_time
  attr_accessor :before_scheduled_end_time
  attr_accessor :before_title
  
  
  # calendar
  def set_start_date
    if self.started_on.present? && self.start_date != self.started_on
      self.update(start_date: self.started_on)
    elsif self.scheduled_started_on.present? && self.start_date != self.scheduled_started_on
      self.update(start_date: self.scheduled_started_on)
    end
  end
  
  def set_end_date
    if self.finished_on.present? && self.end_date != self.finished_on
      self.update(end_date: self.finished_on)
    elsif self.scheduled_finished_on.present? && self.end_date != self.scheduled_finished_on
      self.update(end_date: self.scheduled_finished_on)
    end
  end
  
  def set_schedule
    estimate = self.estimate
    @estimate_info = estimate.estimate_details.left_joins(:material, :construction)
                                              .select('estimate_details.*, materials.name AS material_name, constructions.name AS construction_name')
  end
  
  def set_report_count
    if self.end_date && self.end_date - Date.current > 1 
      days = Date.current - self.start_date
    elsif self.scheduled_started_on && Date.current - self.scheduled_started_on > 0
      days = Date.current - self.scheduled_started_on
    end
    if self.construction_reports.count == days
      self.update(report_count: true)
    else
      self.update(report_count: false)
    end
  end
  
  
  private
    
    #----------------------------------------------
      #CALLBACK_METHOD
    #---------------------------------------------
    
    def set_member_code
      if self.member_code.nil? && supplier_id.present?
        supplier = Supplier.find(self.supplier_id)
        member_code_id = supplier.supplier_manager.member_code.id
        self.update(member_code_id: member_code_id)
      end  
    end
    
    def set_started_on
      if self.construction_reports.present?
        first_report = self.construction_reports.order(:work_date).first
        if first_report.start_time.present?
          self.update(started_on: first_report.work_date)
        end
      end
    end
    
    def set_finished_on
      if self.construction_reports.present?
        if last_report = self.construction_reports.where(report: "completed").order(:work_date).last
          self.update(finished_on: last_report.work_date)
        end
      end
    end
    
    def change_status
      if self.started_on.present? && self.finished_on.present?
        self.update(status: "completed")
      elsif self.started_on.present?
        self.update(status: "progress")
      else
        self.update(status: "not_started")
      end
    end
    
    # calendar
    def set_start_date
      if self.started_on.present?
        self.update(start_date: self.started_on)
      elsif self.scheduled_started_on.present?
        self.update(start_date: self.scheduled_started_on)
      end
    end
    
    def set_end_date
      if self.finished_on.present?
        self.update(end_date: self.finished_on)
      elsif self.scheduled_finished_on.present?
        self.update(end_date: self.scheduled_finished_on)
      end
    end
    
    def member_name_update
      member_code = MemberCode.find(self.member_code_id)
      self.member_name = member_code.member_name_from_member_code
    end
    
    def create_notification
      set_member_code
      if self.member_code_id.present?
        Notification.create(category: 4, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id, construction_schedule_id: self.id)
      end
    end
    
    def update_notification
      if self.before_member_code.present?
        Notification.create(category: 4, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id, schedule_id: self.id)
        Notification.create(category: 4, action_type: 2, sender_id: self.sender, reciever_id: self.before_member_code, schedule_id: self.id,
                            before_value_1: self.before_scheduled_date, before_value_2: self.scheduled_start_time,
                            before_value_3: self.before_scheduled_end_time, before_value_4: self.before_title)
      elsif self.before_scheduled_date != nil || self.before_scheduled_start_time != nil || self.before_scheduled_end_time != nil
        Notification.create(category: 4, action_type: 1, sender_id: self.sender, reciever_id: self.member_code_id, schedule_id: self.id,
                            before_value_1: self.before_scheduled_date, before_value_2: self.scheduled_start_time,
                            before_value_3: self.before_scheduled_end_time)
      end
    end
    
    def destroy_notification
      Notification.create(category: 4, action_type: 2, sender_id: self.sender, reciever_id: self.member_code_id,
                          before_value_1: self.scheduled_date, before_value_2: self.scheduled_start_time,
                          before_value_3: self.scheduled_end_time, before_value_4: self.title)
    end
  
    #----------------------------------------------
      #VALIDATION_METHOD
    #---------------------------------------------
    
    def scheduled_finished_on_is_after_started_on
      if scheduled_started_on.present? && scheduled_finished_on.present? && scheduled_started_on >= scheduled_finished_on
        errors.add(:scheduled_finished_on, "は開始予定時刻以降を入力してください") 
      end
    end
    
    def finished_on_is_before_today
      if finished_on.present? && finished_on > Date.current
        errors.add(:finished_on, "は本日以降の日を設定できません")
      end
    end
    
    def necessary_of_started_on
      if finished_on.present? && started_on.nil?
        errors.add(:started_on, "着工日が登録されていません")
      end
    end
  
end
