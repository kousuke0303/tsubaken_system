class AttractMethod < ApplicationRecord
  has_many :estimate_matters
  acts_as_list

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  validate :prevent_update_first_record, on: :update

  def prevent_update_first_record
    errors.add(:base, "この集客方法は編集できません")
  end
end
