class Attendance < ApplicationRecord
  belongs_to :member_code

  validates :worked_on, presence: true
  validate :started_is_with_finished
  validate :finished_is_after_started

  attr_accessor :employee_type

  before_save { save_working_minutes }

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
