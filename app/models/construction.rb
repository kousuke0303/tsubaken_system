class Construction < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { maximum: 30 }, null: false
  validates :name, length: { maximum: 300 }
end
