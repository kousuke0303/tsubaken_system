class Instruction < ApplicationRecord
  
  belongs_to :estimate_matter, optional: true
  
  acts_as_list
  
  validates :title, presence: true
  validates :content, presence: true
  
end
