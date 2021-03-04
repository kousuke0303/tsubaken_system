class Industry < ApplicationRecord
  has_many :industry_suppliers, dependent: :destroy
  has_many :suppliers, through: :industry_suppliers
  acts_as_list
  
  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }
end
