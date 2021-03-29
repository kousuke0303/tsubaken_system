class ReportCover < ApplicationRecord
  belongs_to :matter
  belongs_to :publisher
  
  validates :title, presence: true, length: { maximum: 30 }, uniqueness: true
end
