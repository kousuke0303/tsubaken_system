class Manager < ApplicationRecord
  
  before_save { self.email = email.downcase if email.present? }
  after_initialize :set_joined_on, on: :create
  after_initialize :default_set, on: :create
  after_commit :create_member_code, on: :create
  after_find :update_for_avaliable
  after_find :set_password_condition
  
  has_one :member_code, dependent: :destroy
  belongs_to :department
  belongs_to :schedule, optional: true
  
  has_many :attendances, dependent: :destroy
  has_one_attached :avator

  validates :name, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :phone, format: { with: VALID_PHONE_REGEX }, allow_blank: true
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }, allow_blank: true
  validates :postal_code, format: { with: VALID_POSTAL_CODE_REGEX }, presence: true
  validates :prefecture_code, presence: true
  validates :address_city, presence: true
  validates :address_street, presence: true
  validate :manager_login_id_is_correct?
  # validate :joined_with_resigned
  # validate :resigned_is_since_joined

  attr_accessor :password_condition

  scope :enrolled, -> { where('resigned_on IS ? OR resigned_on > ?', nil, Date.current)}
  scope :retired, -> { where('resigned_on <= ?', Date.current) }
  scope :with_departments, -> { 
    left_joins(:department).
    select(
      "managers.*",
      "departments.name AS department_name",
      "departments.position"
    ).order(position: :asc)
  }
  
  # ---------------------------------------------------------
    # DEVISE関連
  # ---------------------------------------------------------
  
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
  
  private
  
    #---------------------------------------------------
     # CALLBACK_METHOD
    #---------------------------------------------------
    
    def set_joined_on
      unless self.joined_on
        self.joined_on = Date.current
      end
    end
    
    def default_set
      if self.login_id == nil || self.login_id.empty? 
        self.login_id = "MN-" + "#{SecureRandom.hex(3)}"
      end
      if self.department_id == nil
        self.department_id = 1
      end
    end
    
    def create_member_code
      unless MemberCode.find_by(manager_id: self.id)
        MemberCode.create(manager_id: self.id)
      end
    end
    
    def update_for_avaliable
      if self.avaliable == true && self.resigned_on.present?
        if Date.today > self.resigned_on
          self.update(avaliable: false)
        end
      elsif self.avaliable == false && self.joined_on.present?
        if Date.today >= self.joined_on
          self.update(avaliable: true)
        end
      elsif self.avaliable == true && self.joined_on.present?
        if Date.today < self.joined_on
          self.update(avaliable: false)
        end
      end
    end
    
    def set_password_condition
      if self.valid_password?("password")
        self.password_condition = false
      else
        self.password_condition = true
      end
    end
    
    #---------------------------------------------------
     # VALIDATE_METHOD
    #---------------------------------------------------
    
    # マネージャーの従業員IDは「MN-」から始めさせる
    def manager_login_id_is_correct?
      errors.add(:login_id, "は「MN-」から始めてください") if login_id.present? && !login_id.start_with?("MN-")
    end
  
    # # 退社日は入社日がないとNG
    # def joined_with_resigned
    #   errors.add(:joined_on, "を入力してください") if !self.joined_on.present? && self.resigned_on.present?
    # end
  
    # 退社日は入社日以降
    # def resigned_is_since_joined
    #   if self.joined_on.present? && self.resigned_on.present? && self.joined_on > self.resigned_on
    #     errors.add(:resigned_on, "は入社日以降にしてください")
    #   end
    # end
  
end