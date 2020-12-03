class Kind < ApplicationRecord
  belongs_to :category

  validates :title, presence: true, length: { maximum: 30 }
  validates :amount, presence: true, length: { maximum: 10 }
end
