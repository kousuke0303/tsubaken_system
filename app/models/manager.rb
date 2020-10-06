class Manager < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :employee_id, presence: true, length: { in: 8..10 }, uniqueness: true
  validates :email, length: { maximum: 254 }
  validate :manager_employee_id_is_correct?
  validate :joined_with_resigned
  validate :resigned_is_since_joined

  has_many :events
  has_many :manager_events
  has_many :manager_event_titles
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:employee_id]

  # マネージャーの従業員IDは「MN-」から始めさせる
  def manager_employee_id_is_correct?
    errors.add(:employee_id, "は「MN-」から始めてください。") if employee_id.present? && employee_id[0..2] != "MN-"
  end

  # 退社日は入社日がないとNG
  def joined_with_resigned
    errors.add(:joined_on, "を入力してください。") if !self.joined_on.present? && self.resigned_on.present?
  end

  # 退社日は入社日以降
  def resigned_is_since_joined
    if self.joined_on.present? && self.resigned_on.present? && self.joined_on > self.resigned_on
      errors.add(:resigned_on, "は入社日以降にしてください。")
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
