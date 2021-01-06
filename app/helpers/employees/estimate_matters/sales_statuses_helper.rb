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
  
  def status_member_name(sales_status)
    case sales_status.sales_status_member.authority
    when "admin"
      @member_name = Admin.find(sales_status.sales_status_member.member_id).name
    when "manager"
      @member_name = Manager.find(sales_status.sales_status_member.member_id).name
    when "staff"
      @member_name = Staff.find(sales_status.sales_status_member.member_id).name
    when "external_staff"
      @member_name = ExternalStaff.find(sales_status.sales_status_member.member_id).name
    else 
      @member_name = "Error"
    end
  end
      
    
end
