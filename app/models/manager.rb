class Manager < ApplicationRecord
  validates :name, presence: true, length: { maximum: 20 }
  validates :employee_id, presence: true, length: { in: 8..10 }
  
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :events
  has_many :manager_events
  has_many :manager_event_titles
  
  # パラメーター変更
  def to_param
    public_uid ? public_uid : super()
  end

  def date_cannot_be_in_the_past
    if employee_id.present? && employee_id[1..4] != "MNG-"
      errors.add(:employee_id, ":は「MNG-」から始めてください。")
    end
  end
end
