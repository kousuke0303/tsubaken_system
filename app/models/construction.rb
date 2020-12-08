class Construction < ApplicationRecord
  has_many :children, class_name: "Construction", foreign_key: "parent_id", dependent: :destroy
  belongs_to :parent, class_name: "Construction", foreign_key: "parent_id", optional: true
  belongs_to :category

  validates :name, presence: true, length: { maximum: 30 }, null: false
  validates :name, length: { maximum: 300 }

  scope :are_default, -> { 
                          where(default: true).left_joins(:category).select("categories.*",
                                                                            "constructions.*",
                                                                            "categories.name AS category_name").order(category_id: "ASC")
                          }
end
