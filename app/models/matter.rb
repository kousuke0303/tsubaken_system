class Matter < ApplicationRecord
  has_many :matter_managers
  has_many :managers, through: :matter_managers
  
  has_many :clients
  accepts_nested_attributes_for :clients
  
  def to_param
    matter_uid ? matter_uid : super()
  end
end
