class Manager < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :employee_id, presence: true, length: { in: 8..10 }
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }
  before_save { self.email = email.downcase }

  has_many :events
  has_many :manager_events
  has_many :manager_event_titles
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  # パラメーター変更
  def to_param
    public_uid ? public_uid : super()
  end

  # マネージャーの従業員IDは「MN-」から始めさせる
  def manager_employee_id_is_correct?
    if employee_id.present? && employee_id[1..3] != "MN-"
      errors.add(:employee_id, ":は「MN-」から始めてください。")
    end
  end
end
