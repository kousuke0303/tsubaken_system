class ReportCover < ApplicationRecord
  belongs_to :matter
  belongs_to :publisher
  
  accepts_nested_attributes_for :matter
  
  validates :title, presence: true, length: { maximum: 30 }, uniqueness: true
  validates :created_on, presence: true

  def img_status(img_id)
    img_id.present? ? "選択済" : "未選択"
  end
end
