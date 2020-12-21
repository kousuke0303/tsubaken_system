class Certificate < ApplicationRecord
  has_many_attached :images
  belongs_to :image, optional: true
  belongs_to :message, optional: true
  belongs_to :estimate_matters, optional: true
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :default, presence: true
end
