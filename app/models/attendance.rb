class Attendance < ApplicationRecord
  validates :worked_on, presence: true
  validate :started_is_with_finished
  validate :finished_is_after_started
  validate :require_worker

  attr_accessor :employee_type

  before_save { save_working_minutes }

  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true
  
  # scope
  scope :start_exist, -> { where.not(started_at: nil) }
  scope :finish_exist, -> { where.not(finished_at: nil) }
  
  
  # 出勤の無い退勤は無効
  def started_is_with_finished
    errors.add(:started_at, "を入力してください") if started_at.blank? && finished_at.present? 
  end

  # 出勤以前の退勤は無効
  def finished_is_after_started
    errors.add(:finished_at, "は出勤時間以降に入力してください") if started_at.present? && finished_at.present? && finished_at <= started_at
  end

  def require_worker
    errors.add(:base, "勤務者を入力してください") if manager_id.blank? && staff_id.blank? && external_staff_id.blank?
  end

  # 勤務時間(分)を保存
  def save_working_minutes
    if self.started_at.present? && self.finished_at.present?
      start = self.started_at.hour * 60 + self.started_at.min
      finish = self.finished_at.hour * 60 + self.finished_at.min
      self.working_minutes = finish - start
    else
      self.working_minutes = nil
    end
  end
end
