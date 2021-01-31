class Manager < ApplicationRecord
  belongs_to :department
  has_many :attendances, dependent: :destroy
  has_many :schedules
  has_one_attached :avator

  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true
  validate :manager_login_id_is_correct?
  validate :joined_with_resigned
  validate :resigned_is_since_joined

  scope :enrolled, -> { where(resigned_on: nil) }
  scope :retired, -> { where.not(resigned_on: nil) }
  
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]
  
  # マネージャーの従業員IDは「MN-」から始めさせる
  def manager_login_id_is_correct?
    errors.add(:login_id, "は「MN-」から始めてください") if login_id.present? && !login_id.start_with?("MN-")
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

  # ------------------------------以下devise関連------------------------------

  # emailでなくlogin_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login_id = conditions.delete(:login_id)
      where(conditions).where(login_id: login_id).first
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