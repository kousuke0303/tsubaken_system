class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  has_many :categories, dependent: :destroy

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }

  scope :with_categories, -> { left_joins(categories: [:materials, :constructions]).select("estimates.*",
                                                              "categories.*",
                                                              "materials.*",
                                                              "constructions.*",
                                                              "estimates.id AS id",
                                                              "categories.id AS category_id",
                                                              "categories.name AS category_name",
                                                              "materials.id AS material_id",
                                                              "materials.name AS material_name",
                                                              "materials.price AS material_price",
                                                              "materials.unit AS material_unit",
                                                              "materials.amount AS material_amount",
                                                              "constructions.id AS construction_id",
                                                              "constructions.name AS construction_name",
                                                              "constructions.price AS construction_price",
                                                              "constructions.unit AS construction_unit",
                                                              "constructions.amount AS construction_amount") }
end
