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
end
