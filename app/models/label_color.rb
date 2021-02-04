class LabelColor < ApplicationRecord
  has_many :staffs
  acts_as_list

  validates :name, presence: true, length: { maximum: 10 }
  validates :color_code, format: { with: VALID_COLOR_CODE_REGEX }, presence: true
  validates :note, length: { maximum: 30 }
end
