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
  
end
