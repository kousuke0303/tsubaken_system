class Image < ApplicationRecord
  has_many_attached :images
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  has_many :certificates, dependent: :destroy
   
  validates :images, :shooted_on, presence: true
  validate :image_type

  def image_type
    images.each do |image|
      if !image.blob.content_type.in?(%('image/jpeg image/png image/gif image/bmp image/psd image/tiff'))
        image.purge
        errors.add(:images, 'データをアップロードしてください')
      end
    end
  end
  
  def poster
    if self.admin_id.present?
      Admin.find(admin_id).name
    elsif self.manager_id.present?
      Manager.find(manager_id).name
    elsif self.staff_id.present?
      Staff.find(staff_id).name
    elsif self.external_staff_id.present?
      ExternalStaff.find(external_staff_id).name
    end
  end
end
