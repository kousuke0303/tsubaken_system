class Supplier < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true

  has_many :external_staffs, dependent: :destroy
  has_many :supplier_matters, dependent: :destroy
  has_many :matters, through: :supplier_matters
  has_many :industry_suppliers, dependent: :destroy
  has_many :industries, through: :industry_suppliers
  accepts_nested_attributes_for :industry_suppliers, allow_destroy: true
end
