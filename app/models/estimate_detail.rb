class EstimateDetail < ApplicationRecord
  belongs_to :estimate
  belongs_to :category
  belongs_to :material, optional: true
  belongs_to :construction, optional: true

  before_save :calc_total

  validates :category_name, presence: true
  validates :note, length: { maximum: 100 }
  
  with_options on: :object_update do |object_update|
    object_update.validates :amount, presence: true
  end
  
  # 単価と数量から合計金額を保存
  def calc_total
    price.present? && amount.present? ? self.total = price * amount : self.total = 0
  end
  
end
