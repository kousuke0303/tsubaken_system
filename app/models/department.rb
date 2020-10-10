class Department < ApplicationRecord
  has_many :managers
  has_many :staffs
  
  validates :name, presence: true, length: { maximum: 30 }
end
