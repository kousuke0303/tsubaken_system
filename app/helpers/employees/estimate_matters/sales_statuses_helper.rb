module Employees::EstimateMatters::SalesStatusesHelper
  
  def editor_name(sales_status)
    if sales_status.sales_status_editor.member_name.present?
      @editor_name = sales_status.sales_status_editor.member_name
    else
      @editor_name = "未登録"
    end
  end
  
  def schedule_save?(sales_status)
    if Schedule.find_by(sales_status_id: sales_status.id).present?
      "登録済み"
    else
      "無し"
    end
  end
    
end
