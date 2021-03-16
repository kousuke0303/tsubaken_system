class Construction < ApplicationRecord
  belongs_to :category
  has_many :estimate_details
  has_many :adopted_estimate_details
  
  attr_accessor :accept
  
  validates :name, presence: true, length: { maximum: 30 }
  before_save :calc_total

  scope :includes_category, -> { 
    joins(:category).includes(:category).order(classification: :asc, position: :asc)
  }

  # 引数に入れた見積案件の持つ工事のみを返す
  scope :of_estimate_matter, -> (estimate_matter_id) { left_joins(category: :estimate).where(estimates: { estimate_matter_id: estimate_matter_id }) }

  # 数量と単価があれば、その合計値をtotalカラムに保存
  def calc_total    
    self.total = price * amount if price.present? && amount.present?
  end
end
