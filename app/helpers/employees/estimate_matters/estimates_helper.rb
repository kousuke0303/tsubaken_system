module Employees::EstimateMatters::EstimatesHelper
  
  def plan_row_span(estimate)
    estimate.estimate_details.count
  end
  
  def category_row_span(estimate, category_id)
    estimate.estimate_details.where(category_id: category_id).count
  end
  
  def detail_calculation(detail)
    return detail.amount * detail.price
  end

  # 見積のラベルカラーを返す
  def label_color_of_estimate(label_color = "")
    if label_color.present?
      PlanName.label_colors.keys[label_color]      
    else
      PlanName.label_colors.keys[0]
    end
  end
  
end
