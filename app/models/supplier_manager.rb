class SupplierManager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  before_save { self.email = email.downcase if email.present? }
  after_commit :create_member_code, on: :create
  after_find :set_password_condition
  
  
  has_one :member_code, dependent: :destroy
  belongs_to :supplier, optional: true
  # belongs_to :schedule, optional: true
  
  has_one_attached :avator
  
  
  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validate :supplier_manager_login_id_is_correct?
  
  attr_accessor :password_condition
  
  # --------------------------------------------------
    # DEVISE関連
  # --------------------------------------------------
  
  devise :database_authenticatable, :registerable, :rememberable, :validatable, authentication_keys: [:login_id]

  # ログイン条件追加
  def active_for_authentication?
    super && self.avaliable
  end
  
  # 上記エラーメッセージ変更
  def inactive_message
    self.avaliable ? super : :not_avaliable
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
  
  #---------------------------------------------------
     # INSTANCE_METHOD
  #---------------------------------------------------
  
  def matters
    self.supplier.matters
  end
  
  def tasks
    Task.joins(:member_code).where(member_codes: {id: self.member_code.id})
  end
  
  def attendances
    Attendance.joins(:member_code).where(member_codes: {id: self.member_code.id})
  end
  
  def recieve_notifications
    self.member_code.recieve_notifications.where(status: 0)
  end
  
  private
  
  #---------------------------------------------------
     # VALIDATE_METHOD
  #---------------------------------------------------
    
    # ログインIDは「SP(外注先ID)-」から始めさせる
    def supplier_manager_login_id_is_correct?
      errors.add(:login_id, "は「SM-」から始めてください") if login_id.present? && !login_id.start_with?("SM-")
    end
    
  #---------------------------------------------------
     # CALLBACK_METHOD
  #---------------------------------------------------
    
    def create_member_code
      unless MemberCode.find_by(supplier_manager_id: self.id)
        MemberCode.create(supplier_manager_id: self.id)
      end
    end
    
    def set_password_condition
      if self.valid_password?("password")
        self.password_condition = false
      else
        self.password_condition = true
      end
    end
  
end
