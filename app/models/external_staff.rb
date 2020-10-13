class ExternalStaff < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validates :kana, presence: true, length: { maximum: 30 }
  validates :login_id, presence: true, length: { in: 8..12 }, uniqueness: true
  validates :email, length: { maximum: 254 }
  validate :external_staff_login_id_is_correct?

  attr_accessor :login_id_body
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable, authentication_keys: [:login_id]

  # ログインIDは「SP(外注先ID)-」から始めさせる
  def external_staff_login_id_is_correct?
    errors.add(:login_id, "は「SP(外注先ID)-」から始めてください") if login_id.present? && login_id[0..1] != "SP"
  end
end
