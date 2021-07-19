class ExternalStaff < ApplicationRecord
  
  after_initialize :default_set, on: :create
  before_save { self.email = email.downcase if email.present? }
  after_commit :create_member_code, on: :create
  after_find :update_for_avaliable
  after_find :set_password_condition
  
  has_one :member_code, dependent: :destroy
  belongs_to :vendor, optional: true

  has_one_attached :avator

  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validate :external_staff_login_id_is_correct?

  attr_accessor :password_condition
  
  scope :enrolled, -> { where('resigned_on IS ? OR resigned_on > ?', nil, Date.current) }
  scope :retired, -> { where('resigned_on <= ?', Date.current) }
  scope :avaliable, -> { where(avaliable: true)}
  scope :not_avaliable, -> { where(avaliable: false)}

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
  
  def boss
    VendorManager.find_by(vendor_id: self.vendor_id)
  end
  
  def matters
    Matter.joins(:member_codes).where(member_codes: {id: self.member_code.id})
  end

  def construction_schedules
    ConstructionSchedule.where(member_code_id: self.member_code.id)
  end

  # def estimate_matters
  #   EstimateMatter.joins(:member_codes).where(member_codes: {id: self.member_code.id})
  # end

  # def schedules
  #   Schedule.joins(:member_code).where(member_codes: {id: self.member_code.id})
  # end

  def tasks
    Task.joins(:member_code).where(member_codes: {id: self.member_code.id})
  end

  # def attendances
  #   Attendance.joins(:member_code).where(member_codes: {id: self.member_code.id})
  # end

  def recieve_notifications
    self.member_code.recieve_notifications.where(status: 0)
  end

  private

    #---------------------------------------------------
     # CALLBACK_METHOD
    #---------------------------------------------------

    def create_member_code
      unless MemberCode.find_by(external_staff_id: self.id)
        MemberCode.create(external_staff_id: self.id)
      end
    end

    def update_for_avaliable
      if self.avaliable == true && self.resigned_on.present?
        if Date.current >= self.resigned_on
          self.update(avaliable: false)
        end
      elsif self.avaliable == false && self.resigned_on.nil?
        self.update(avaliable: true)
      end
    end

    def set_password_condition
      if self.valid_password?("password")
        self.password_condition = false
      else
        self.password_condition = true
      end
    end
    
    def default_set
      if self.login_id == nil || self.login_id.empty? 
        self.login_id = "ES-" + "#{SecureRandom.hex(3)}"
      end
    end

    #---------------------------------------------------
     # VALIDATE_METHOD
    #---------------------------------------------------

    # ログインIDは「ES(外注先ID)-」から始めさせる
    def external_staff_login_id_is_correct?
      errors.add(:login_id, "は「ES-」から始めてください") if login_id.present? && !login_id.start_with?("ES-")
    end
    
end
