class Certificate < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :message, optional: true
  belongs_to :estimate_matter, optional: true
  
  acts_as_list scope: :estimate_matter
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }
end
