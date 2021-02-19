class Estimate < ApplicationRecord
  belongs_to :estimate_matter
  belongs_to :plan_name, optional: true
  belongs_to :matter, optional: true
  has_many :estimate_details, dependent: :destroy
  acts_as_list scope: :estimate_matter

  attr_accessor :category_ids  # コピーするデフォルトカテゴリのid配列を受け取る

  validates :title, presence: true, length: { maximum: 30 }
  validates :total_price, allow_blank: true, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 10000000 }
  validates :discount, presence: true, numericality: { only_integer: true }

  scope :with_categories, -> {
    left_joins(:categories, :plan_name).select(
      "estimates.*",
      "categories.*",
      "plan_names.label_color",
      "estimates.id AS id",
      "categories.id AS category_id",
      "categories.name AS category_name",
      "categories.sort_number AS category_number"
    ).order(:category_number)
  }

  # 端数値引があれば、引いた合計金額を返す
  def after_discount
    total_price - discount
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
