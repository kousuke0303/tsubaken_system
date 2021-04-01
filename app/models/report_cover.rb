class ReportCover < ApplicationRecord
  belongs_to :matter
  belongs_to :publisher
  
  validates :title, presence: true, length: { maximum: 30 }, uniqueness: true

  def img_status(img_id)
    img_id.present? ? "選択済" : "未選択"
  end
end
