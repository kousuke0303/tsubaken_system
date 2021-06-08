class MemberCode < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :manager, optional: true
  belongs_to :staff, optional: true
  belongs_to :external_staff, optional: true
  belongs_to :supplier_manager, optional: true
  belongs_to :client, optional: true

  has_many :attendances, dependent: :destroy
  
  has_many :estimate_matter_member_codes, dependent: :destroy
  has_many :estimate_matters, through: :estimate_matter_member_codes
  
  has_many :matter_member_codes, dependent: :destroy
  has_many :matters, through: :matter_member_codes
  
  has_many :send_notifications, class_name: "Notification", foreign_key: "sender_id", dependent: :destroy
  has_many :recieve_notifications, class_name: "Notification", foreign_key: "reciever_id", dependent: :destroy
  
  has_one :schedule
  has_one :sales_status
  has_one :sales_status_editor
  has_one :task
  
  scope :sort_auth, -> { order(:external_staff_id, :staff_id, :manager_id, :admin_id) }
  
  # 利用できるメンバーの全コード
  def self.all_member_code_of_avaliable
    remove_ids = []
    if Manager.where(avaliable: false).present?
      remove_manager_codes = MemberCode.includes(:manager).where(managers: { avaliable: false })
      remove_manager_code_ids = remove_manager_codes.ids
      remove_ids.push(remove_manager_code_ids).flatten
    end
    if Staff.where(avaliable: false).present? 
      remove_staff_codes = MemberCode.joins(:staff).where(staffs: { avaliable: false })
      remove_staff_code_ids = remove_staff_codes.ids
      remove_ids.push(remove_staff_code_ids).flatten
    end
    if ExternalStaff.where(avaliable: false).present? 
      remove_external_staff_codes = MemberCode.joins(:external_staff).where(external_staffs: { avaliable: false })
      remove_external_staff_code_ids = remove_external_staff_codes.ids
      remove_ids.push(remove_external_staff_code_ids).flatten
    end
    unless remove_ids.empty?
      remove_ids = remove_ids.flatten
      MemberCode.left_joins(:admin, :manager, :staff, :external_staff)
                .where.not(id: remove_ids)
                .sort_auth
    else
      MemberCode.all.sort_auth
    end
  end
  
  def self.all_member_for_select_form
    all_member_codes = self.all_member_code_of_avaliable
    member_arrey = []
    all_member_codes.each do |member_code|
      date = []
      date.push(member_code.member_name_from_member_code)
      date.push(member_code.id)
      member_arrey.push(date)
    end
    return member_arrey
  end
  
  
  #-----------------------------------------------------
    # INSTANCE_METHOD
  #---------------------------------------------------
  
  # 親インスタンス
  def parent
    if self.admin_id.present?
     self.admin
    elsif self.manager_id.present?
      self.manager
    elsif self.staff_id.present?
      self.staff
    elsif self.external_staff.present?
      self.external_staff
    elsif self.supplier_manager.present?
      self.supplier_manager
    end
  end
  
  # 親インスタンスの名前
  def member_name_from_member_code
    self.parent.name
  end

end
