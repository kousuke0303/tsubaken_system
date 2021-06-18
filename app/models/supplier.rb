class Supplier < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true

  has_many :external_staffs, dependent: :destroy
  has_one :supplier_manager, dependent: :destroy
  
  has_many :supplier_estimate_matters, dependent: :destroy
  has_many :estimate_matters, through: :supplier_estimate_matters
  
  has_many :supplier_matters, dependent: :destroy
  has_many :matters, through: :supplier_matters
  
  has_many :industry_suppliers, dependent: :destroy
  has_many :industries, through: :industry_suppliers
  accepts_nested_attributes_for :industry_suppliers, allow_destroy: true
  has_many :construction_schedules, dependent: :destroy
  
  def supplier_member_ids
    external_staffs_code_ids_for_supplier = MemberCode.joins(:external_staff).where(external_staff_id: self.external_staffs.ids)
                                                      .where(external_staffs: {avaliable: true}).ids
    supplier_members_member_code_ids = external_staffs_code_ids_for_supplier << self.supplier_manager.member_code.id
    return supplier_members_member_code_ids
  end
  
  def supplier_member_ids_for_matter_select(matter)
    external_staffs_code_ids_for_supplier = MemberCode.joins(:matters, :external_staff).where(external_staff_id: self.external_staffs.ids)
                                                                                      .where(external_staffs: {avaliable: true})
                                                                                      .where(matters: {id: matter.id}).ids
    supplier_members_member_code_ids = external_staffs_code_ids_for_supplier << self.supplier_manager.member_code.id
    return supplier_members_member_code_ids
  end
  
end
