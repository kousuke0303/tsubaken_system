module Employees::EstimateMatters::EstimatesHelper
  
  def estimate_type(number)
    type = ["A", "B", "C", "D", "E", "F", "G", "H"]
    return type[number]
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
