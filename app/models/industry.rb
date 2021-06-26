class Industry < ApplicationRecord
  has_many :industry_vendors, dependent: :destroy
  has_many :vendors, through: :industry_vendors
  acts_as_list

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }
end
