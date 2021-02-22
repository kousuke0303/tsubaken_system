class AttractMethod < ApplicationRecord
  has_many :estimate_matters
  acts_as_list

  validates :name, presence: true, length: { maximum: 30 }
end
