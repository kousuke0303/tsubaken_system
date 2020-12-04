class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  has_many :categories, dependent: :destroy

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }

  scope :with_categories, -> { left_joins(:categories).select("estimates.*",
                                                              "categories.*",
                                                              "estimates.id AS id") }
end
