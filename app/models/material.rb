class Material < ApplicationRecord
  has_many :category_materials, dependent: :destroy
  has_many :categories, through: :category_materials
  has_many :estimate_details
  belongs_to :plan_name
  
  attr_accessor :accept

  validates :name, presence: true, uniqueness: true, length: { maximum: 30 }
  validates :service_life, length: { maximum: 30 }
  before_save :calc_total

  scope :include_category, -> { 
    joins(:categories, :plan_name).includes([:categories, :plan_name]).order(:plan_name_id, 'categories.position': :asc)
  }

  # 引数に入れた見積案件の持つ工事のみを返す
  scope :of_estimate_matter, -> (estimate_matter_id) { left_joins(category: :estimate).where(estimates: { estimate_matter_id: estimate_matter_id }) }

  # 数量と単価があれば、その合計値をtotalカラムに保存
  def calc_total    
    self.total = price * amount if price.present? && amount.present?
  end
end
