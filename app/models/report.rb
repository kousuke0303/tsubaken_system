class Report < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :matter, optional: true

  acts_as_list scope: :matter
  
  validates :title, presence: true, length: { maximum: 30 }
end
