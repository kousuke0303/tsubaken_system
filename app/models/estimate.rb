class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  has_many :categories, dependent: :destroy

  validates :title, presence: true, length: { maximum: 30 }
end
