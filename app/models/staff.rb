class Staff < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 20 }
  validates :employee_id, presence: true, length: { in: 8..10 }
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { in: 6..12 }
  validate :staff_employee_id_is_correct?

  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :staff_events, dependent: :destroy
  has_many :staff_event_titles, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:employee_id]
  
  # ## scope #########################################
  scope :employee_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 1))
  }
  
  scope :outsourcing_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 0))
  }

  # スタッフの従業員IDは「ST-」から始めさせる
  def staff_employee_id_is_correct?
    if employee_id.present? && employee_id[0..2] != "ST-"
      errors.add(:employee_id, ":は「ST-」から始めてください。")
    end
  end

  # emailでなくemployee_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if employee_id = conditions.delete(:employee_id)
      where(conditions).where(employee_id: employee_id).first
    else
      where(conditions).first
    end
  end

  # 登録時にemailを不要にする
  def email_required?
    false
  end

  def will_save_change_to_email?
    false
  end
end
