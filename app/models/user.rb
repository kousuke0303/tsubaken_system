class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # アソシエーション
  has_many :managers, through: :manager_users
  has_many :manager_users, dependent: :delete_all
  accepts_nested_attributes_for :manager_users
end
