class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :kind, optional: true

  validates :title, presence: true, length: { maximum: 30 }
end
