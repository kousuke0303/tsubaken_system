class Client < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..10 }, uniqueness: true
  validates :email, length: { maximum: 254 }
  validate :client_login_id_is_correct?
  
  has_many :matters, dependent: :destroy
  
  enum gender: {male: "男", female: "女"}

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:login_id]
         
  # 顧客IDは「CL-」から始めさせる
  def client_login_id_is_correct?
    errors.add(:login_id, "は「CL-」から始めてください") if login_id.present? && login_id[0..2] != "CL-"
  end
end
