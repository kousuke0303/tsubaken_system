class Material < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }, null: false
  validates :service_life, length: { maximum: 30 }
end
