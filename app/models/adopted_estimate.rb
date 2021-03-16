class AdoptedEstimate < ApplicationRecord
  belongs_to :matter
  belongs_to :plan_name
  has_many :adopted_estimate_details, dependent: :destroy

  validates :total_price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 10000000 }
  validates :discount, presence: true, numericality: { only_integer: true }

  # 端数値引があれば、引いた合計金額を返す
  def after_discount
    total_price - discount
  end
end
