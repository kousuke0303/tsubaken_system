class Staff < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # アソシエーション
  has_many :manager_staffs, dependent: :delete_all
  has_many :managers, through: :manager_staffs
  
  has_many :matter_staffs, dependent: :destroy
  has_many :matters, through: :matter_staffs
  has_many :attendance, dependent: :destroy

  has_many :staff_events

  has_many :staff_event_titles

end
