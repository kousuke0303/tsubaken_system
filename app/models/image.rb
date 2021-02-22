class Image < ApplicationRecord
  has_one_attached :image
  belongs_to :estimate_matter, optional: true
  belongs_to :matter, optional: true
  has_many :certificates, dependent: :destroy
   
  validates :image, :shooted_on, presence: true
  
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
