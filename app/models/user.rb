class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, 
         :recoverable, :rememberable, :validatable, :omniauthable
  # アソシエーション
  has_many :manager_users, dependent: :delete_all
  has_many :managers, through: :manager_users
 
  
  has_many :user_social_profiles, dependent: :destroy
  
  has_many :matter_users, dependent: :destroy
  has_many :matters, through: :matter_users
  
  # userが連結した案件の依頼会社（複数の場合あり）を抽出
  scope :requested_of_company, -> (user, matter) {
    joins(matters: :managers).select('managers.company, managers.id').where(id: user.id).merge(Matter.where(id: matter.id))
  }
  
  def user_social_profile(provider)
    user_social_profiles.select{ |sp| sp.provider == provider.to_s }.first
  end
end
