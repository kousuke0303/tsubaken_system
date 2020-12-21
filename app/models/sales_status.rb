class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :staff,             optional: true
  belongs_to :external_staff,    optional: true

  validates :status, presence: true
  validates :conducted_on, presence: true
  validates :note, length: { maximum: 300 }
  validate :require_only_practitioner

  enum status: { other: 0, appointment: 1, inspection: 2, calculation: 3, immediately: 4, contract: 5, contemplation_month: 6,
                 contemplation_year: 7, lost: 8, lost_by_other: 9, chasing: 10, waiting_insurance: 11, consideration: 12 }

  scope :with_practitioner, -> { 
    left_joins(:staff, :external_staff).select(
      "sales_statuses.*",
      "staffs.name AS staff_name",
      "external_staffs.name AS external_staff_name",
      ).order(created_at: "DESC")
  }

  # 一名の実施者を必須にする
  def require_only_practitioner
    if staff_id.nil? && external_staff_id.nil?
      errors.add(:base, "実施者を入力してください")
    elsif staff_id.present? && external_staff_id.present?
      errors.add(:base, "実施者は一名のみ入力可能です")
    end
  end
end
