class Client < ApplicationRecord
  
  before_save { self.email = email.downcase if email.present? }
  after_find :set_password_condition
  after_commit :create_member_code, on: :create
  
  has_many :estimate_matters, dependent: :destroy
  has_many :matters, dependent: :destroy
  has_one :member_code, dependent: :destroy
  
  # has_one_attached :avator
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }, format: { with: VALID_KANA_REGEX }
  validates :phone_1, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :phone_2, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :fax, format: { with: VALID_FAX_REGEX }, allow_blank: true
  validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validate :client_login_id_is_correct?
  
  attr_accessor :password_condition
  
  enum gender: { male: 0, female: 1 }


  # 名前検索
  scope :get_by_name, ->(name) { where("name like ?", "%#{ name }%") }
  # 成約顧客
  scope :has_matter, ->{ joins(:matters).order(created_at: :desc).group_by{|client| client.id}} 
  # 未成約顧客
  scope :not_have_matter, ->{ left_joins(:matters).order(created_at: :desc)
                                                  .where( matters: { id: nil })
                                                  .group_by{|client| client.id}}
  # お問合せから絞込
  scope :search_by_inquiry, ->(name, kana, phone, email){
    where("name like ?", "%#{ name }%").
    or(Client.where(kana: kana)).
    or(Client.where(phone_1: phone)).
    or(Client.where(phone_2: phone)).
    or(Client.where(email: email))
  }
  
  #---------------------------------------------------
    # DEVISE関連
  #---------------------------------------------------
  
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]
  
  # ログイン条件追加
  def active_for_authentication?
    super && self.avaliable
  end
  
  # 上記エラーメッセージ変更
  def inactive_message
    self.avaliable ? super : :not_avaliable
  end

  # 顧客IDは「CL-」から始めさせる
  def client_login_id_is_correct?
    errors.add(:login_id, "は「CL-」から始めてください") if login_id.present? && !login_id.start_with?("CL-")
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
  
  #---------------------------------------------------
    # INSTANCE_METHOD
  #---------------------------------------------------
  
  
  # def estimate_matters
  #   EstimateMatter.joins(:sales_statuses).where(client_id: self.id)
  #                                       .where(sales_statuses: {status: 4})
  # end
  
  def certificates
    Certificate.joins(:estimate_matter).where(estimate_matters: {client_id: self.id})
  end
  
  def reports
    Report.joins(:matter).where(matters: {client_id: self.id})
  end
  
  def recieve_notifications
    self.member_code.recieve_notifications.where(status: 0)
  end
  
  private
    #---------------------------------------------------
          # CALLBACK_METHOD
    #---------------------------------------------------
  
    def set_password_condition
      if self.valid_password?("password")
        self.password_condition = false
      else
        self.password_condition = true
      end
    end
    
    def create_member_code
      unless MemberCode.find_by(client_id: self.id)
        MemberCode.create(client_id: self.id)
      end
    end
  
end
