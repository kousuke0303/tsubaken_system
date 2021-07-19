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
  validate :only_one_cover, on: :update
  
  def poster
    if self.member_code_id.present?
      MemberCode.find(self.member_code_id).parent.name
    end
  end
  
  def only_one_cover
    if self.estimate_matter_id.present?
      estimate_matter = self.estimate_matter
      if self.cover_list == true && estimate_matter.images.where(cover_list: true).count >= 1
        errors.add(:base, "既に表紙に設定されている画像から表紙の設定を外してください")
      end
    end
  end
  
end
