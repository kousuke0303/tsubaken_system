class Category < ApplicationRecord
  has_many :materials, dependent: :destroy
  has_many :constructions, dependent: :destroy
  belongs_to :estimate, optional: true

  validates :name, presence: true, length: { maximum: 30 }
end
