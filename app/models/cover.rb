class Cover < ApplicationRecord
  belongs_to :estimate_matter, optional: true
  belongs_to :image, optional: true
  belongs_to :publisher, optional: true
  
  validates :title, presence: true, uniqueness: true
end
