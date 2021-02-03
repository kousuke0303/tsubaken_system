class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  has_one :sales_status_editor, dependent: :destroy
  has_one :sales_status_member, dependent: :destroy

  validates :status, presence: true
  validates :scheduled_date, presence: true
  validates :note, length: { maximum: 300 }
  validate :scheduled_end_time_is_after_start_time
  validate :except_duplicate_schedule, on: :schedule_register
  validate :except_duplicate_schedule_for_update, on: :update
  
  # 成約見積案件
  scope :contracted_estimate_matter, -> (estimate_matter_id) { joins(:estimate_matter)
                                        .where("(estimate_matter_id = ?)", estimate_matter_id)
                                        .where("(status = ?)", 6) }

  enum status: { not_set: 0, other: 1, appointment: 2, inspection: 3, calculation: 4, immediately: 5, contract: 6, contemplation_month: 7,
                 contemplation_year: 8, lost: 9, lost_by_other: 10, chasing: 11, waiting_insurance: 12, consideration: 13, start_of_construction: 14 }
  
  enum register_for_schedule: { not_register: 0, schedule_register: 1, schedule_update: 2, schedule_destroy: 3 }
  
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
