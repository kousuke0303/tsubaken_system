class Matter < ApplicationRecord
  has_many :matter_managers, dependent: :destroy
  has_many :managers, through: :matter_managers
  
  has_many :matter_submanagers, dependent: :destroy
  has_many :submanagers, through: :matter_submanagers
  
  has_many :matter_staffs, dependent: :destroy
  has_many :staffs, through: :matter_staffs
  
  has_many :matter_users, dependent: :destroy
  has_many :users, through: :matter_users
  
  has_many :clients, dependent: :destroy
  accepts_nested_attributes_for :clients, allow_destroy: true
  
  def to_param
    matter_uid ? matter_uid : super()
  end
end
