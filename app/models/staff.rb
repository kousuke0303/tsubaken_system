class Staff < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # アソシエーション
  has_many :manager_staffs, dependent: :delete_all
  has_many :managers, through: :manager_staffs
  accepts_nested_attributes_for :manager_staffs, allow_destroy: true
  
  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :attendances, class_name: "Staffs::Attendance", dependent: :destroy


  has_many :staff_events

  has_many :staff_event_titles
  
  # ## scope #########################################
  scope :employee_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 1))
  }
  
  scope :outsourcing_staff, ->(dependent_manager){
    joins(:manager_staffs).merge(ManagerStaff.where(manager_id: dependent_manager.id)).merge(ManagerStaff.where(employee: 0))
  }

end
