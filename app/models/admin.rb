class Admin < ApplicationRecord
  belongs_to :schedule, optional: true
  
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validate :admin_login_id_is_correct?

  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]

  has_one_attached :avator

  # 管理者の従業員IDは「AD-」から始めさせる
  def admin_login_id_is_correct?
    errors.add(:login_id, "は「AD-」から始めてください") if login_id.present? && !login_id.start_with?("AD-")
  end

  # emailでなくlogin_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login_id = conditions.delete(:login_id)
      where(conditions).where("login_id = ?", login_id).first
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

  # ログインID変更時のreset_password_token不要にする
  def will_save_change_to_login_id?
    false
  end
end
