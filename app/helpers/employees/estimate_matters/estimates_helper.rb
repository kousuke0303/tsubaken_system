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
  
  def estimate_color(estimate)
    estimate.plan_name_id.present? ? estimate.plan_name.label_color.color_code : LabelColor.first.color_code
  end
end
