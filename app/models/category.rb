class Category < ApplicationRecord
  has_many :materials, dependent: :destroy
  has_many :constructions, dependent: :destroy
  belongs_to :estimate, optional: true

  attr_accessor :material_ids  # コピーするデフォルト素材のid配列を受け取る
  attr_accessor :construction_ids  # コピーするデフォルト工事のid配列を受け取る

  validates :name, presence: true, length: { maximum: 30 }
end
