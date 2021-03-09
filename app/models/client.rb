class Client < ApplicationRecord
  has_many :estimate_matters, dependent: :destroy
  has_one_attached :avator
  
  before_save { self.email = email.downcase if email.present? }

  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }, format: { with: VALID_KANA_REGEX }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validate :client_login_id_is_correct?
  
  enum gender: { male: 0, female: 1 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]

  # 名前検索
  scope :get_by_name, ->(name) { where("name like ?", "%#{ name }%") }
  # 成約顧客
  scope :has_matter, ->{ joins(estimate_matters: :matter) } 
  # 未成約顧客
  scope :not_have_matter, ->{ left_joins(estimate_matters: :matter).where(estimate_matters: { matters: { estimate_matter_id: nil }}) }
  # お問合せから絞込
  scope :search_by_inquiry, ->(name, kana, phone, email){
    where("name like ?", "%#{ name }%").
    or(Client.where(kana: kana)).
    or(Client.where(phone_1: phone)).
    or(Client.where(phone_2: phone)).
    or(Client.where(email: email))
  }

  # 顧客IDは「CL-」から始めさせる
  def client_login_id_is_correct?
    errors.add(:login_id, "は「CL-」から始めてください") if login_id.present? && !login_id.start_with?("CL-")
  end

  # emailでなくlogin_idを認証キーにする
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login_id = conditions.delete(:login_id)
      where(conditions).where(login_id: login_id, confirmed: true).first
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
