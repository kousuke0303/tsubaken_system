class Matter < ApplicationRecord
  belongs_to :client
  has_many :matter_managers, dependent: :destroy
  has_many :managers, through: :matter_managers
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :tasks, dependent: :destroy
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  accepts_nested_attributes_for :matter_managers, allow_destroy: true
  accepts_nested_attributes_for :matter_staffs, allow_destroy: true
  accepts_nested_attributes_for :supplier_matters, allow_destroy: true

  validates :title, presence: true, length: { maximum: 30 }
end
