class LabelColor < ApplicationRecord
  has_many :staffs
  has_many :plan_names
  acts_as_list
  
  attr_accessor :accept

  validates :name, presence: true, uniqueness: true, length: { maximum: 10 }
  validates :color_code, uniqueness: true, format: { with: VALID_COLOR_CODE_REGEX }, presence: true
  validates :note, length: { maximum: 30 }
end
