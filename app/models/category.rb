class Category < ApplicationRecord
  has_many :kinds, dependent: :destroy
  belongs_to :estimate, optional: true

  validates :name, presence: true, length: { maximum: 30 }
end
