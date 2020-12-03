class Estimate < ApplicationRecord
  belongs_to :estimate_matter

  validates :title, presence: true, length: { maximum: 30 }
end
