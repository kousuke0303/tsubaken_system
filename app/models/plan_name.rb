class PlanName < ApplicationRecord
  belongs_to :label_color
  has_many :estimates, dependent: :nullify

  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  acts_as_list

  # ラベルカラーと結合
  scope :with_colors, -> { order(position: :asc).left_joins(:label_color).select("plan_names.*","label_colors.color_code AS color_code") }
end
