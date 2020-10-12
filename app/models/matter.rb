class Matter < ApplicationRecord
  has_many :supplier_matters, dependent: :destroy
  has_many :suppliers, through: :supplier_matters
  belongs_to :client
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  has_many :tasks, dependent: :destroy
   
end
