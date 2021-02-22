module Employees::EstimateMatters::EstimatesHelper
  # 案件採用のラベルを返す
  def recruitmented_label
    content_tag(:div, "案件採用", class: "adopted-msg")
  end

  # 見積案件中、最初の見積なら@disabled = "disable"
  def is_first_position(estimate)
    @disabled =  estimate.position == 1 ? "disabled" : nil
  end

  # 見積案件中、最後の見積なら@disabled = "disable"
  def is_last_position(estimate, size)
    @disabled = estimate.position == size ? "disabled" : nil
  end

  def plan_row_span(estimate)
    estimate.estimate_details.count
  end
  
  def category_row_span(estimate, category_id)
    estimate.estimate_details.where(category_id: category_id).count
  end
  
  def estimate_color(estimate)
    if estimate.plan_name_id.present?
      estimate.plan_name.label_color.color_code
    else
      LabelColor.first.color_code
    end
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
