class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :staff,             optional: true
  belongs_to :external_staff,    optional: true

  validates :status, presence: true
  validates :conducted_on, presence: true
  validates :note, length: { maximum: 300 }
  validate :require_only_practitioner

  enum status: { not_set:0, other: 1, appointment: 2, inspection: 3, calculation: 4, immediately: 5, contract: 6, contemplation_month: 7,
                 contemplation_year: 8, lost: 9, lost_by_other: 10, chasing: 11, waiting_insurance: 12, consideration: 13 }

  scope :with_practitioner, -> { 
    left_joins(:staff, :external_staff).select(
      "sales_statuses.*",
      "staffs.name AS staff_name",
      "external_staffs.name AS external_staff_name",
      ).order(created_at: "DESC")
  }

  # 未設定のステータス以外は、一名の実施者を必須にする
  def require_only_practitioner
    unless status == "not_set"      
      errors.add(:base, "実施者を入力してください") if staff_id.nil? && external_staff_id.nil?    
      errors.add(:base, "実施者は一名のみ入力可能です") if staff_id.present? && external_staff_id.present?
    end
  end
end
