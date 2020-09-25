class Submanager < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_many :submanager_events
  has_many :submanager_event_titles 
  has_many :matter_submanagers, dependent: :destroy
  has_many :matters, through: :matter_submanagers
  
  has_many :attendances, class_name: "Submanagers::Attendance", dependent: :destroy
end
