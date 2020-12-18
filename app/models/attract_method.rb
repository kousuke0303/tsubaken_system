class AttractMethod < ApplicationRecord
  has_many :estimate_matters

  validates :name, presence: true, length: { maximum: 30 }
end
