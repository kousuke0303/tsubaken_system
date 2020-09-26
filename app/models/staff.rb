class Staff < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 20 }
  validates :email, length: { maximum: 254 }, format: { with: VALID_EMAIL_REGEX }

  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :staff_events, dependent: :destroy
  has_many :staff_event_titles, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  
  # ## scope #########################################
  scope :employee_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 1))
  }
  
  scope :outsourcing_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 0))
  }

  # スタッフの従業員IDは「ST-」から始めさせる
  def staff_employee_id_is_correct?
    if employee_id.present? && employee_id[1..3] != "ST-"
      errors.add(:employee_id, ":は「ST-」から始めてください。")
    end
  end

end
