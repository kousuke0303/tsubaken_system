class Category < ApplicationRecord
  # has_many :children, class_name: "Category", foreign_key: "parent_id", dependent: :destroy
  has_many :materials, dependent: :destroy
  has_many :constructions, dependent: :destroy
  # belongs_to :estimate, optional: true
  # belongs_to :parent, class_name: "Category", foreign_key: "parent_id", optional: true

  has_many :estimate_details
  
  attr_accessor :material_ids  # コピーするデフォルト素材のid配列を受け取る
  attr_accessor :construction_ids  # コピーするデフォルト工事のid配列を受け取る

  validates :name, presence: true, length: { maximum: 30 }
end
