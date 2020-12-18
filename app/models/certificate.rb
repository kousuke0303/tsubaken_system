class Certificate < ApplicationRecord
  belongs_to :image, optional: true
  belongs_to :message, optional: true
  
  validates :title, presence: true, length: { maximum: 30 }
  validates :content, presence: true, length: { maximum: 300 }
  validates :default, presence: true
end
