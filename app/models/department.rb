class Department < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  
  has_many :managers
  has_many :staffs
end
