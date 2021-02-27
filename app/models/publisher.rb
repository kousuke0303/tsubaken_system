class Publisher < ApplicationRecord
  has_many :estimate_matters, dependent: :destroy
  has_many :covers
  has_one_attached :image
  acts_as_list

  validates :name, presence: true, length: { maximum: 30 }
  validates :phone, format: { with: VALID_PHONE_REGEX }
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true
end
