class Material < ApplicationRecord
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
