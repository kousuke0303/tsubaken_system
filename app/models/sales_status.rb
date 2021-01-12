class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  has_one :sales_status_editor, dependent: :destroy
  has_one :sales_status_member, dependent: :destroy

  validates :status, presence: true
  validates :conducted_on, presence: true
  validates :note, length: { maximum: 300 }

  enum status: { not_set:0, other: 1, appointment: 2, inspection: 3, calculation: 4, immediately: 5, contract: 6, contemplation_month: 7,
                 contemplation_year: 8, lost: 9, lost_by_other: 10, chasing: 11, waiting_insurance: 12, consideration: 13, start_of_construction: 14 }

  
end
