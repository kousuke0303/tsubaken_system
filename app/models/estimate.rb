class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  has_many :categories, dependent: :destroy

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }

  scope :with_categories, -> { left_joins(categories: :materials).select("estimates.*",
                                                              "categories.*",
                                                              "materials.*",
                                                              "estimates.id AS id",
                                                              "categories.id AS category_id",
                                                              "categories.name AS category_name",
                                                              "materials.id AS material_id",
                                                              "materials.name AS material_name",
                                                              "materials.price AS material_price",
                                                              "materials.unit AS material_unit") }
end
