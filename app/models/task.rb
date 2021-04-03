class Task < ApplicationRecord
  
  before_save :member_name_update
  after_commit :add_default_task_for_auto_set, on: :create
  after_commit :create_notification, on: :update
  after_destroy :destroy_notification
  after_find :count
  
  # 自己結合
  has_many :copy_task, class_name: "Task", foreign_key: "default_task_id"
  belongs_to :original, class_name: "Task", foreign_key: "default_task_id", optional: true
  
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  belongs_to :member_code, optional: true
  has_many :notifications, dependent: :destroy

  validates :title, presence: true, length: { maximum: 30 }
  validates :content, length: { maximum: 300 }
  # validate :only_in_charge
  
  
  enum status: { default: 0, relevant: 1, ongoing: 2, finished: 3 }
   
  scope :are_default, -> { default.order(alert: :desc)
                                  .order(auto_set: :desc)
                                  .order(default_task_id_count: :desc) }
  scope :are_matter_default_task, -> {default.where(auto_set: false).order(default_task_id_count: :desc) }
  scope :are_relevant, -> { relevant.order(:sort_order) }
  scope :are_ongoing, -> { ongoing.order(:sort_order) }
  scope :are_finished, -> { finished.order(:sort_order) }
  scope :auto_set_lists, -> { where(status: 0, auto_set: true)} 
  
  # notification関連
  attr_accessor :notification_type
  attr_accessor :sender #member_code.id
  attr_accessor :before_member_code
  attr_accessor :before_title #before_value_1
  attr_accessor :before_content #before_value_2
  
  def self.alert_lists
    setting_alert_ids = Task.where(status: 0, alert: true).ids
    Task.where(default_task_id: setting_alert_ids).where.not(status: 3)
  end    
  
  #-----------------------------------------------------
    # INSTANCE_METHOD
  #-----------------------------------------------------

  def self.title_from_id(id)
    Task.find(id).title    
  end

  # sort_orderを正しい連番に更新
  def self.reload_sort_order(tasks)
    tasks.order(:sort_order).each_with_index do |task, index|
      task.update_column(:sort_order, index)
    end
  end

  # sort_orderを+1に更新
  def self.increment_sort_order(matter, status, sort_order)
    matter.tasks.where("status >= ?", status).where("sort_order >= ?", sort_order).each do |task|
      new_sort_order = task.sort_order.to_i + 1
      task.update_column(:sort_order, new_sort_order)
    end
  end

  # sort_orderを-1に更新
  def self.decrement_sort_order(matter, status, sort_order)
    matter.tasks.where("status >= ?", status).where("sort_order <= ?", sort_order).each do |task|
      unless task.sort_order == 0
        new_sort_order = task.sort_order.to_i - 1
        task.update_column(:sort_order, new_sort_order)
      end
    end
  end
  
  private
  
  #-----------------------------------------------------
    # VALIDATION_METHOD
  #-----------------------------------------------------
  
  # 担当者は一名に制限
  def only_in_charge
    errors.add(:base, "担当者は一名までです") if self.staff && self.external_staff
  end
  
  
  #-----------------------------------------------------
    # CALLBACK_METHOD
  #-----------------------------------------------------
  
  def count
    if self.default?
      count = Task.where("default_task_id = ?", self.id).count
      self.update_column(:default_task_id_count, count)
    end  
  end
  
  def member_name_update
    if self.member_code.present?
      member_code = MemberCode.find(self.member_code_id)
      self.member_name = member_code.member_name_from_member_code
    end
  end
  
  def add_default_task_for_auto_set
    if self.default? && self.auto_set?
      matters_for_add_task = Matter.where.not(status: 2)
      matters_for_add_task.each do |matter|
        matter.tasks.create(title: self.title, content: self.content,
                            status: 1, default_task_id: self.id)
      end
    end
  end
  
  # 通常の割り振りタスクの通知
  def create_notification
    if self.status != "default" && self.notification_type == "create_destroy"
      self.notifications.create(category: 2, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id)
      self.notifications.create(category: 2, action_type: 2, sender_id: self.sender, reciever_id: self.before_member_code)
    elsif self.status != "default" && self.notification_type == "create"
      self.notifications.create(category: 2, action_type: 0, sender_id: self.sender, reciever_id: self.member_code_id)
    elsif self.status != "default" && self.notification_type == "update"
      self.notifications.create(category: 2, action_type: 1, sender_id: self.sender, reciever_id: self.member_code_id,
                                before_value_1: self.before_title)
    end
  end
  
  def destroy_notification
    if self.status != "default"
      Notification.create(category: 2, action_type: 2, sender_id: self.sender, reciever_id: self.member_code_id,
                          before_value_1: self.title, before_value_2: self.matter.title)
    end
  end
end
