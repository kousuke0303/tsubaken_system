class Category < ApplicationRecord
  has_many :kinds, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
end
