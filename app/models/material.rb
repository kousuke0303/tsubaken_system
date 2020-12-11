class Material < ApplicationRecord
  has_many :children, class_name: "Material", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Material", foreign_key: "parent_id", optional: true
  belongs_to :category

  validates :name, presence: true, length: { maximum: 30 }, null: false
  validates :service_life, length: { maximum: 30 }
  validates :name, length: { maximum: 300 }

  scope :are_default, -> { 
                          where(default: true).left_joins(:category).select("categories.*",
                                                                            "materials.*",
                                                                            "categories.name AS category_name").order(category_id: "ASC")
                          }

  # 引数に入れた見積案件の持つ工事のみを返す
  scope :of_estimate_matter, -> (estimate_matter_id) { left_joins(category: :estimate).where(estimates: { estimate_matter_id: estimate_matter_id }) }
end
