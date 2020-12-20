class SalesStatus < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :staff,             optional: true
  belongs_to :external_staff,    optional: true

  validates :status, presence: true
  validates :conducted_on, presence: true
  validates :note, length: { maximum: 300 }

  enum status: { other: 0, appointment: 1, inspection: 2, calculation: 3, immediately: 4, contract: 5, contemplation_month: 6,
                 contemplation_year: 7, lost: 8, lost_by_other: 9, chasing: 10, waiting_insurance: 11, consideration: 12 }
end
