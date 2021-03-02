class Department < ApplicationRecord
  has_many :managers
  has_many :staffs
  acts_as_list

  before_destroy :prevent_delete_first
  validates :name, presence: true,
                   uniqueness: true,
                   length: { maximum: 30 }
  validate :restrict_edit_first

  # 無所属部署は編集不可
  def restrict_edit_first
    errors.add(:base, "無所属部署は編集できません") if id == 1 && name != "無所属"
  end

  # 無所属部署は削除不可
  def prevent_delete_first
    if id == 1
      errors.add(:base, "無所属部署は削除できません")
      throw :abort
    end
  end
end
