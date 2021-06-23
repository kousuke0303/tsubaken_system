# frozen_string_literal: true

module EstimateDecorator
  
  def name
    PlanName.find(self.plan_name_id).name
  end
  
  def color
    PlanName.find(self.plan_name_id).label_color.color_code
  end
  
end
