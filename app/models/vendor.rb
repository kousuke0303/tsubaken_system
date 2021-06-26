class Vendor < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true

  has_many :external_staffs, dependent: :destroy
  has_one :vendor_manager, dependent: :destroy

  has_many :vendor_estimate_matters, dependent: :destroy
  has_many :estimate_matters, through: :vendor_estimate_matters
  has_many :referral_matters, class_name: "EstimateMatter", foreign_key: "supplier_id"

  has_many :vendor_matters, dependent: :destroy
  has_many :matters, through: :vendor_matters

  has_many :industry_vendors, dependent: :destroy
  has_many :industries, through: :industry_vendors
  accepts_nested_attributes_for :industry_vendors, allow_destroy: true
  has_many :construction_schedules, dependent: :destroy

  def vendor_member_ids
    external_staffs_code_ids_for_vendor = MemberCode.joins(:external_staff).where(external_staff_id: self.external_staffs.ids)
                                                    .where(external_staffs: {avaliable: true}).ids
    vendor_members_member_code_ids = external_staffs_code_ids_for_vendor << self.vendor_manager.member_code.id
    return vendor_members_member_code_ids
  end

  def vendor_member_ids_for_matter_select(matter)
    external_staffs_code_ids_for_vendor = MemberCode.joins(:matters, :external_staff).where(external_staff_id: self.external_staffs.ids)
                                                                                     .where(external_staffs: {avaliable: true})
                                                                                     .where(matters: {id: matter.id}).ids
    vendor_members_member_code_ids = external_staffs_code_ids_for_vendor << self.vendor_manager.member_code.id
    return vendor_members_member_code_ids
  end
end
