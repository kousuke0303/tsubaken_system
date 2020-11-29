class Category < ApplicationRecord
  has_many :kinds, dependent: :destroy

  validates :title, presence: true, length: { maximum: 30 }
end
