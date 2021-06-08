module Employees::EstimateMattersHelper
  
  def sales_status_disp(status)
    content_tag(:span, "#{status}", class: "badge badge-info")
  end
  
end