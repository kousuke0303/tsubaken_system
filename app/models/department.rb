class Department < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :restrict_edit_first
  
  has_many :managers
  has_many :staffs

  # 無所属部署は編集不可
  def restrict_edit_first
    errors.add(:base, "無所属部署は編集できません") if id == 1 && name != "無所属"
  end
end
