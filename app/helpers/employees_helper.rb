module EmployeesHelper
  
   # 編集権限があるかどうか
  def update_authority?(estimate_matter)
    if current_admin || current_manager
      return true
    elsif current_staff
      if estimate_matter.staffs.find(current_staff.id).present?
        return true
      else
        return false
      end
    elsif current_external_staff
      if estimate_matter.external_staffs.find(current_external_staff.id).present?
        return true
      else
        return false
      end
    end
  end
  
  # 担当者の名前表示
  def member_name(schedule_or_sales_status)
    if schedule_or_sales_status.admin_id.present?
      Admin.find(schedule_or_sales_status.admin_id).name
    elsif schedule_or_sales_status.manager_id.present?
      Manager.find(schedule_or_sales_status.manager_id).name
    elsif schedule_or_sales_status.staff_id.present?
      Staff.find(schedule_or_sales_status.staff_id).name
    elsif schedule_or_sales_status.external_staff_id.present?
      ExternalStaff.find(schedule_or_sales_status.external_staff_id).name
    else
      return false
    end
  end
  
  # STAFF_COLOR
  def staff_color(id)
    Staff.find(id).label_color.color_code
  end
end