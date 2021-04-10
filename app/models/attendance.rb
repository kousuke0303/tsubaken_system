class Attendance < ApplicationRecord
  belongs_to :member_code

  validates :worked_on, presence: true
  validate :started_is_with_finished
  validate :finished_is_after_started

  attr_accessor :employee_type
  attr_accessor :manager_id
  attr_accessor :staff_id
  attr_accessor :external_staff_id

  before_save { save_working_minutes }

  scope :start_exist, -> { where.not(started_at: nil) }
  scope :finish_exist, -> { where.not(finished_at: nil) }
  scope :with_member_codes, -> { 
    left_joins(member_code: [:manager, :staff, :external_staff]).
    select(
      "attendances.*",
      "member_codes.*",
      "managers.name AS manager_name",
      "staffs.name AS staff_name",
      "external_staffs.name AS external_staff_name"
    )
  }
  
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
