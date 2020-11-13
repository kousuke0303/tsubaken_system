class Staff < ApplicationRecord
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validate :staff_login_id_is_correct?

  belongs_to :department
  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :staff_events, dependent: :destroy
  has_many :staff_event_titles, dependent: :destroy
  has_many :attendances, dependent: :destroy
  has_many :tasks, dependent: :destroy

  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]

  # スタッフの従業員IDは「ST-」から始めさせる
  def staff_login_id_is_correct?
    errors.add(:login_id, "は「ST-」から始めてください") if login_id.present? && !login_id.start_with?("ST-")
  end

  # emailでなくlogin_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login_id = conditions.delete(:login_id)
      where(conditions).where(login_id: login_id).first
    else
      where(conditions).first
    end
  end

  # 退社日は入社日がないとNG
  def joined_with_resigned
    errors.add(:joined_on, "を入力してください") if !self.joined_on.present? && self.resigned_on.present?
  end

  # 退社日は入社日以降
  def resigned_is_since_joined
    if self.joined_on.present? && self.resigned_on.present? && self.joined_on > self.resigned_on
      errors.add(:resigned_on, "は入社日以降にしてください")
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
