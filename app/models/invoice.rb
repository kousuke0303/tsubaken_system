class Invoice < ApplicationRecord
  belongs_to :matter
  belongs_to :plan_name
  has_many :invoice_details, dependent: :destroy

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :total_price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 10000000 }
  validates :discount, presence: true, numericality: { only_integer: true }

  # 端数値引があれば、引いた合計金額を返す
  def after_discount
    total_price - discount
  end

  # 合計金額を計算
  def calc_total_price
    total_price = 0
    invoice_details.each do |detail|
      total_price += detail.total
    end
    self.update(total_price: total_price)
  end

  # 端数値引後の消費税を返す
  def consumption_tax
    (after_discount * 0.1).to_i
  end

  # 端数値引後の合計金額(消費税込)
  def total_with_tax
    after_discount + consumption_tax
  end
end
