class Manager < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  #### アソシエーション 
  #---------------------------------------------------------
  has_many :submanagers, dependent: :destroy

  has_many :manager_users
  has_many :users, through: :manager_users

  has_many :manager_staffs
  has_many :staffs, through: :manager_staffs
  
  has_many :matter_managers
  has_many :matters, through: :matter_managers

  has_many :events

  has_many :manager_events

  has_many :manager_event_titles
  
  has_many :manager_tasks, dependent: :destroy
  has_many :tasks, through: :manager_tasks
  
  has_many :suppliers, dependent: :destroy
  
  #### scope 
  #---------------------------------------------------------
  
  
  # パラメーター変更
  def to_param
    public_uid ? public_uid : super()
  end
  
end
