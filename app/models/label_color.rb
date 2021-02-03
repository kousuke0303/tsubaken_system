class LabelColor < ApplicationRecord
  validates :name, presence: true, length: { maximum: 10 }
  validates :color_code, presence: true
  validates :note, length: { maximum: 30 }
end
