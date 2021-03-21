class InvoiceDetail < ApplicationRecord
  belongs_to :invoice
  belongs_to :category
  belongs_to :material, optional: true
  belongs_to :construction, optional: true
  
  before_save :calc_total

  validates :category_name, presence: true
  validates :price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999999 }
  validates :amount, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 99999999 }
  validates :note, length: { maximum: 100 }
  
  with_options on: :object_update do
    validates :unit, presence: true
    validates :amount, presence: true
  end
  
  # 単価と数量から合計金額を保存
  def calc_total
    price.present? && amount.present? ? self.total = price * amount : self.total = 0
  end
end
