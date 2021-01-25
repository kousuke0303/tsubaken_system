class PlanName < ApplicationRecord
  has_many :estimates, dependent: :nullify

  validates :name, presence: true, length: { maximum: 30 }
  validates :color, presence: true
  acts_as_list

  enum color: { gray: 0, red: 1, green: 2, purple: 3, orange: 4, blue: 5 }
end
