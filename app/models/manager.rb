class Manager < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :events
  has_many :manager_events
  has_many :manager_event_titles
  has_many :manager_tasks, dependent: :destroy
  has_many :tasks, through: :manager_tasks
  
  # パラメーター変更
  def to_param
    public_uid ? public_uid : super()
  end
  
end
