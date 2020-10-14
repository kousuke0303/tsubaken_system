class Attendance < ApplicationRecord
  validates :worked_on, presence: true
  validate :started_is_with_finished
  validate :finished_is_after_started

  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true

  # 出勤の無い退勤は無効
  def started_is_with_finished
    errors.add(:started_at, "を入力してください") if started_at.blank? && finished_at.present? 
  end

  # 出勤以前の退勤は無効
  def finished_is_after_started
    errors.add(:finished_at, "は出勤時間以降に入力してください") if started_at.present? && finished_at.present? && finished_at <= started_at
  end
end
