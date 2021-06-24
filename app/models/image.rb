class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  belongs_to :member_code, optional: true
  has_many :certificates
  has_many :reports
  has_one :cover
  has_many :construction_schedule_images, dependent: :destroy
  has_many :construction_schedules, through: :construction_schedule_images
   
  validates :shooted_on, presence: true
  validates :image, presence: true
  
  def poster
    if self.member_code_id.present?
      MemberCode.find(self.member_code_id).parent.name
    end
  end
  
end
