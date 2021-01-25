module Employees::EstimateMatters::EstimatesHelper
  
  def estimate_type(number)
    type = ["A", "B", "C", "D", "E", "F", "G", "H"]
    return type[number]
  end
  
  def estimate_index_variable(estimate)
    @estimate_details = EstimateDetail.where(estimate_id: estimate.id).order(:sort_number)
    @first_detail = @estimate_details.first
  end
  
  def plan_row_span(estimate)
    estimate.estimate_details.count
  end
  
  def category_row_span(estimate, category_id)
    estimate.estimate_details.where(category_id: category_id).count
  end
  
  def category_name(id)
    Category.find(id).name
  end
end
