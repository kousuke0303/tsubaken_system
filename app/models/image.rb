class Image < ApplicationRecord
  has_many_attached :images
  belongs_to :matter, optional: true
   
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
end
