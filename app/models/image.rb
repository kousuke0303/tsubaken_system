class Image < ApplicationRecord
  has_many_attached :images
  belongs_to :matter, inverse_of: :images, optional: true
   
  validates :images, :shooted_on, presence: true
  validate :image_type

  def image_type
    images.each do |image|
      if !image.blob.content_type.in?(%('image/jpeg image/png image/gif image/bmp image/psd'))
        image.purge
        errors.add(:images, 'データをアップロードしてください')
      end
    end
  end
  
  # 内容更新
  def self.edit_image_content(images)
    images.each do |image|
      image.update(content: image.content)
    end
  end
  
  # 写真削除
  def self.delete_image_contents(image)
    image.purge
  end
end
