class ConstructionReport < ApplicationRecord
  
  after_commit :create_notifications, on: :update
  
  belongs_to :construction_schedule
  has_many :notifications, dependent: :destroy
  
  validate :only_one_report_for_a_day, on: :create
  validate :end_time_is_start_time
  
  
  enum report: { not_set: 0, good: 1, delay: 2, re_scuedule: 3, completed: 4}
  enum reason: { no_select: 0, rain: 1, other: 2}
  
  scope :uncheck_reports, ->{ where.not(admin_check: true) }
  scope :uncheck_reports_for_supplier, ->{ where.not(sm_check: true) }
  
  attr_accessor :sender #member_code_id
  
  private
  
  ####### VALIDATION ###########################
  
    def only_one_report_for_a_day
      construction_schedule = self.construction_schedule
      target_day = self.work_date
      if construction_schedule.construction_reports.where(work_date: target_day).present?
        errors.add(:work_date, "は既に存在しております")
      end
    end
    
    def end_time_is_start_time
      if start_time.present? && end_time.present? && start_time >= end_time
        errors.add(:end_time, "は開始時刻以降を入力してください") 
      end
    end
    
  ######## CALLBACK #############################
    
    def create_notifications
      if self.report != "not_set" || self.reason != "no_select"
        construction_schedule = self.construction_schedule
        matter = construction_schedule.matter
        supplier_manager_code_id = construction_schedule.supplier.supplier_manager.member_code.id
        recievers_ids = matter.member_ids_in_charge.push(supplier_manager_code_id) 
        recievers_ids.each do |reciever|
          self.notifications.create(category: 3, action_type: 0, sender_id: self.sender, reciever_id: reciever)
        end
      end
    end
    
end
