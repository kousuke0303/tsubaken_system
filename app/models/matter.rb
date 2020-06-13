class Matter < ApplicationRecord
  has_many :matter_managers
  
  def to_param
    matter_uid ? matter_uid : super()
  end
end
