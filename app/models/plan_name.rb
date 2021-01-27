class PlanName < ApplicationRecord
  has_many :estimates, dependent: :nullify

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :label_color, presence: true
  acts_as_list

  enum label_color: { "#6c757d": 0, "#17a2b8": 1, "#fd7e14": 2, "#8b66cd": 3, "#28a745": 4, "#dc3545": 5 }
end
