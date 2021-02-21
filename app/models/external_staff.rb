class ExternalStaff < ApplicationRecord
  belongs_to :supplier, optional: true
  belongs_to :schedule, optional: true
  
  has_many :attendances, dependent: :destroy
  has_many :schedules
  has_many :estimate_matter_external_staffs, dependent: :destroy
  has_many :matter_external_staffs, dependent: :destroy
  has_many :estimate_matters, through: :estimate_matter_external_staffs
  has_many :matters, through: :matter_external_staffs
  has_many :tasks, dependent: :destroy
  has_one_attached :avator
  
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validate :external_staff_login_id_is_correct?

  attr_accessor :login_id_body
  
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]

  # ログインIDは「SP(外注先ID)-」から始めさせる
  def external_staff_login_id_is_correct?
    errors.add(:login_id, "は「ES-」から始めてください") if login_id.present? && !login_id.start_with?("ES-")
  end

  # ------------------------------以下devise関連------------------------------

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
