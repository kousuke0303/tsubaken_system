class Manager < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 20 }
  validates :employee_id, presence: true, length: { in: 8..10 }
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }
  validates :password, presence: true, length: { in: 6..12 }
  validate :manager_employee_id_is_correct?

  has_many :events
  has_many :manager_events
  has_many :manager_event_titles
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:employee_id]

  # マネージャーの従業員IDは「MN-」から始めさせる
  def manager_employee_id_is_correct?
    if employee_id.present? && employee_id[0..2] != "MN-"
      errors.add(:employee_id, ":は「MN-」から始めてください。")
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
