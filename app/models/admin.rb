class Admin < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }, uniqueness: true
  validates :employee_id, presence: true, length: { in: 8..10 }, uniqueness: true
  validates :password, presence: true, length: { in: 6..12 }
  validate :admin_employee_id_is_correct?
  validate :only_admin?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:employee_id]

  # 管理者アカウントは一つに制限
  def only_admin?
    errors.add(:base, "管理者アカウントは既に存在します。") if Admin.exists?
  end

  # 管理者の従業員IDは「AD-」から始めさせる
  def admin_employee_id_is_correct?
    if employee_id.present? && employee_id[0..2] != "AD-"
      errors.add(:employee_id, ":は「AD-」から始めてください。")
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
