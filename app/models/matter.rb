class Matter < ApplicationRecord
  has_many :matter_managers, dependent: :destroy
  has_many :managers, through: :matter_managers
  
  has_many :clients, dependent: :destroy
  accepts_nested_attributes_for :clients, allow_destroy: true
  
  def to_param
    matter_uid ? matter_uid : super()
  end
end
