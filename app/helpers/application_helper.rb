module ApplicationHelper
  
  def avator(login_user)
    login_user.avator.attached? ? login_user.avator : login_user.name[0, 1]
  end 
  
  def all_members
    all_members = []
    Admin.all.each do |admin|
      all_members << { auth: admin.auth, id: admin.id, name: admin.name }
    end
    Manager.all.each do |manager|
      all_members << { auth: manager.auth, id: manager.id, name: manager.name }
    end
    Staff.all.each do |staff|
      all_members << { auth: staff.auth, id: staff.id, name: staff.name }
    end
    ExternalStaff.all.each do |external_staff|
      all_members << { auth: external_staff.auth, id: external_staff.id, name: external_staff.name }
    end
    return all_members
  end
      
      
    
    
  # ---------------------------------------------------------
      # ATTENDANCE
  # ---------------------------------------------------------
  
  def working_calculation(attendance)
    if attendance.finished_at.present?
      day_working_calc = (attendance.finished_at - attendance.started_at) / 3600
      disp_day_working_calc = day_working_calc.floor(2) 
      return sprintf("%.2f", disp_day_working_calc)
    end
  end
  
  def finished_nil?(attendance)
    if attendance.worked_on != Date.today && attendance.started_at.present? && attendance.finished_at == nil
      return true
    end
  end
  
  def own_finished_at_nil_notification(object_user)
    yesterday = Date.today - 1
    attendance = object_user.attendances.find_by(worked_on: yesterday)
    if attendance.started_at.present? && attendance.finished_at == nil
      return "昨日の退勤処理がありません。管理者に報告してください！"
    end
  end
  
  def object_user_name(attendance)
    if attendance.manager_id.present?
      return Manager.find(attendance.manager.id).name
    elsif attendance.staff_id.present?
      return Staff.find(attendance.staff_id).name
    elsif attendance.external_staff_id.present?
      return ExternalStaff.find(attendance.external_staff_id).name
    end
  end
end
