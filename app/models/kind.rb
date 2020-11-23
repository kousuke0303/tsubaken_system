class Kind < ApplicationRecord
  belongs_to :category
  has_many :quotations

  validates :name, presence: true, length: { maximum: 30 }
end
