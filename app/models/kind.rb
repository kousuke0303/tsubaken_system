class Kind < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { maximum: 30 }
end
