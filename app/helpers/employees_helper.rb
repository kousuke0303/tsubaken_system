module EmployeesHelper
  
  # 編集権限があるかどうか(1対多) ※estimate_matter
  def update_authority?(object)
    if current_admin || current_manager
      return true
    elsif current_staff
      if object.staffs.find(current_staff.id).present?
        return true
      else
        return false
      end
    elsif current_external_staff
      if object.external_staffs.find(current_external_staff.id).present?
        return true
      else
        return false
      end
    end
  end
  
  # 編集権限があるかどうか(1対1) ※schedule
  def update_authority_for_one?(object)
    if current_admin || current_manager
      return true
    elsif current_staff
      if object.staff_id == current_staff.id
        return true
      else
        return false
      end
    elsif current_external_staff
      if object.external_staff_id == current_external_staff.id
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
  
  #PUBLISHER_NAME
  def publisher_name(id)
    if id.present?
      Publisher.find(id).name
    else
      false
    end
  end
    
end