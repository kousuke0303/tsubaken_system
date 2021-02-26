class Cover < ApplicationRecord
  belongs_to :estimate_matter, optional: true
  belongs_to :image, optional: true
  
  validates :title, presence: true
end
