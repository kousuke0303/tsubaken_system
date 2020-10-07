class Admin < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :employee_id, presence: true, length: { in: 8..10 }, uniqueness: true
  validate :admin_employee_id_is_correct?
  validate :admin_is_only

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:employee_id]

  def admin_is_only
    if Admin.exists? && self.id != 1
      errors.add(:base, "管理者アカウントは既に存在します")
    end
  end

  # 管理者の従業員IDは「AD-」から始めさせる
  def admin_employee_id_is_correct?
    errors.add(:employee_id, "は「AD-」から始めてください") if employee_id.present? && employee_id[0..2] != "AD-"
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
