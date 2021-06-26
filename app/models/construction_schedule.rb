class ConstructionSchedule < ApplicationRecord
  
  after_find :set_attr
  before_save :member_name_update
  after_commit :create_notification, on: :create
  after_commit :update_notification, on: :update
  after_destroy :destroy_notification

  belongs_to :matter
  belongs_to :vendor, optional: true
  belongs_to :member_code, optional: true

  has_many :construction_schedule_materials, dependent: :destroy
  has_many :materials, through: :construction_schedule_materials
  has_many :construction_reports, dependent: :destroy
  has_many :construction_schedule_images, dependent: :destroy
  has_many :images, through: :construction_schedule_images
  has_many :notifications, dependent: :destroy

  validates :title, presence: true
  validate :finished_on_is_before_today
  validate :necessary_of_started_on

  with_options on: :normal_commit do |normal_commit|
    normal_commit.validates :scheduled_started_on, presence: true
    normal_commit.validates :scheduled_finished_on, presence: true
    normal_commit.validate :scheduled_finished_on_is_after_started_on
  end

  enum status: { not_started: 0, progress: 1, completed: 2 }

  scope :order_start_date, ->{ order(start_date: "ASC")}
  scope :today_work, -> { where('scheduled_finished_on >= ? and ? >= scheduled_started_on', Date.current, Date.current)}
  scope :before_yesterday_work, -> { where('? >= scheduled_started_on', Date.current.yesterday)}

  # notification用変数
  attr_accessor :sender #member_code_id
  attr_accessor :before_member_code
  attr_accessor :before_scheduled_started_on
  attr_accessor :before_scheduled_finisied_on
  attr_accessor :before_content
  attr_accessor :before_title
  attr_accessor :sender_auth


  # calendar
  def set_start_date_and_end_date
    if self.started_on.present? && self.start_date != self.started_on
      self.update_column(:start_date, self.started_on)
    elsif self.scheduled_started_on.present? && self.start_date != self.scheduled_started_on
      self.update_column(:start_date, self.scheduled_started_on)
    end
    if self.finished_on.present? && self.end_date != self.finished_on
      self.update_column(:end_date, self.finished_on)
    elsif self.scheduled_finished_on.present? && self.end_date != self.scheduled_finished_on
      self.update_column(:end_date, self.scheduled_finished_on)
    end
  end


  private

    #----------------------------------------------
      #CALLBACK_METHOD
    #---------------------------------------------

    def set_attr
      change_status
      set_started_on_or_finished_on
      set_report_count
    end

    # コールバックスキップ
    def change_status
      if self.started_on.present? && self.finished_on.present?
        self.update_column(:status, "completed")
      elsif self.started_on.present?
        self.update_column(:status, "progress")
      else
        self.update_column(:status, "not_started")
      end
    end

    # コールバックスキップ
    def set_started_on_or_finished_on
      if self.construction_reports.present?
        first_report = self.construction_reports.order(:work_date).first
        if first_report.start_time.present?
          self.update_column(:started_on, first_report.work_date)
        end
      end
      if self.construction_reports.present?
        if last_report = self.construction_reports.where(report: "completed").order(:work_date).last
          self.update_column(:finished_on, last_report.work_date)
        end
      end
    end

    # alert
    def set_report_count
      if self.end_date && self.end_date - Date.current > 1
        days = Date.current - self.start_date
      elsif self.scheduled_started_on && Date.current - self.scheduled_started_on > 0
        days = Date.current - self.scheduled_started_on
      end
      if self.construction_reports.count == days
        self.update_column(:report_count, true)
      else
        self.update_column(:report_count, false)
      end
    end

    def member_name_update
      if self.member_code.present?
        member_code = MemberCode.find(self.member_code_id)
        self.member_name = member_code.member_name_from_member_code
      end
    end

    def create_notification
      set_member_code
      if self.member_code_id.present?
        Notification.create(create_notification_attributes)
      end
    end

    def update_notification
      # 外部managerによる更新通知
      if self.sender_auth == "vendor_manager"
        Notification.create(create_notification_attributes)
        # 外部managerから外部スタッフに変更以外の場合は削除通知
        if self.before_member_code != self.sender
          change_attributes = destroy_notification_attributes.merge(reciever_id: self.before_member_code)
          Notification.create(change_attributes)
        end
      # employeeによる更新通知
      else
        set_member_code
        if self.before_member_code.present?
          if self.member_code_id != self.before_member_code
            Notification.create(create_notification_attributes)
            Notification.create(category: 4, action_type: 2, sender_id: self.sender, reciever_id: self.before_member_code, construction_schedule_id: self.id,
                                before_value_1: self.before_scheduled_started_on, before_value_2: self.scheduled_finished_on,
                                before_value_3: self.before_title, before_value_4: self.matter.title)
          else
            Notification.create(category: 4, action_type: 1, sender_id: self.sender, reciever_id: self.member_code_id, construction_schedule_id: self.id,
                                before_value_1: self.before_scheduled_started_on, before_value_2: self.scheduled_finished_on,
                                before_value_3: self.before_title)
          end
        else
          Notification.create(create_notification_attributes)
        end
      end
    end

    def destroy_notification
      # 既に担当者が設定されている場合
      if self.member_code_id.present?
        Notification.create(destroy_notification_attributes)
        # 担当者が外部manager以外の場合
        if self.member_code_id != self.vendor.vendor_manager.member_code.id
          vendor_manager_id = self.vendor.vendor_manager.member_code.id
          change_attributes = destroy_notification_attributes.merge(reciever_id: vendor_manager_id)
          Notification.create(change_attributes)
        end
      end
    end

    def set_member_code
      if self.member_code.nil? && vendor_id.present?
        vendor = Vendor.find(self.vendor_id)
        member_code_id = vendor.vendor_manager.member_code.id
        self.update_column(:member_code_id, member_code_id)
      end
    end

    def create_notification_attributes
      { category: 4,
        action_type: 0,
        sender_id: self.sender,
        reciever_id: self.member_code_id,
        construction_schedule_id: self.id }
    end

    def destroy_notification_attributes
      { category: 4,
        action_type: 2,
        sender_id: self.sender,
        reciever_id: self.member_code_id,
        before_value_1: self.start_date,
        before_value_2: self.end_date,
        before_value_3: self.title,
        before_value_4: self.matter.title }
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
