class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :plan_name, optional: true
  has_one :matter, dependent: :destroy
  has_many :estimate_details, dependent: :destroy

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }
  validates :total_price, allow_blank: true, numericality: { only_integer: true }

  scope :with_categories, -> { 
    left_joins(:categories, :plan_name).select(
      "estimates.*",
      "categories.*",
      "plan_names.label_color",
      "estimates.id AS id",
      "categories.id AS category_id",
      "categories.name AS category_name",
      "categories.sort_number AS category_number"
    ).order(:category_number)
  }
  
end
