class Notification < ApplicationRecord
  
  after_commit :auto_delete, on: :update
  
  belongs_to :schedule, optional: true
  belongs_to :task, optional: true
  belongs_to :construction_report, optional: true
  belongs_to :construction_schedule, optional: true
  
  belongs_to :sender, class_name: 'MemberCode', foreign_key: 'sender_id', optional: true
  belongs_to :reciever, class_name: 'MemberCode', foreign_key: 'reciever_id', optional: true

  enum status: { active: 0, close: 1 }
  enum category: { not_set: 0, schedule: 1, task: 2, report: 3, construction_schedule: 4 }
  enum action_type: { creation: 0, updation: 1, deletion: 2 }
  
  scope :creation_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 0) }
  scope :updation_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 1) }
  scope :delete_notification_for_schedule, -> { where(status: 0, category: 1, action_type: 2) }
  scope :creation_notification_for_task, -> { where(status: 0, category: 2, action_type: 0) }
  scope :updation_notification_for_task, -> { where(status: 0, category: 2, action_type: 1) }
  scope :delete_notification_for_task, -> { where(status: 0, category: 2, action_type: 2) }
  scope :creation_notification_for_report, -> { where(status: 0, category: 3, action_type: 0)}
  scope :creation_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 0) }
  scope :updation_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 1) }
  scope :delete_notification_for_construction_schedule, -> { where(status: 0, category: 4, action_type: 2) }
  
  private
  
   def auto_delete
     self.destroy if self.status == "close"
   end
    
end
