class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :plan_name, optional: true
  has_many :categories, dependent: :destroy

  attr_accessor :plan_name  # デフォルトプラン名選択用
  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }

  scope :with_categories, -> { 
    left_joins(:categories).select(
      "estimates.*",
      "categories.*",
      "estimates.id AS id",
      "categories.id AS category_id",
      "categories.name AS category_name"
    ) 
  }
end
