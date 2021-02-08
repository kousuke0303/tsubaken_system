module Employees::EstimateMatters::SalesStatusesHelper
  
  def editor_name(sales_status)
    case sales_status.sales_status_editor.authority
    when "admin"
      @editor_name = Admin.find(sales_status.sales_status_editor.member_id).name
    when "manager"
      @editor_name = Manager.find(sales_status.sales_status_editor.member_id).name
    when "staff"
      @editor_name = Staff.find(sales_status.sales_status_editor.member_id).name
    when "external_staff"
      @editor_name = ExternalStaff.find(sales_status.sales_status_editor.member_id).name
    else 
      @editor_name = "Error"
    end
  end
  
  def schedule_save?(sales_status)
    if Schedule.find_by(sales_status_id: sales_status.id).present?
      return "登録済み"
    else
      return "無し"
    end
  end
    
end
