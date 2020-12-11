module ApplicationHelper
  
  def avator(login_user)
    login_user.avator.attached? ? login_user.avator : login_user.name[0, 1]
  end  
    
  # ---------------------------------------------------------
      # ATTENDANCE
  # ---------------------------------------------------------
  
  def working_calculation(attendance)
    if attendance.finished_at.present?
      day_working_calc = (attendance.finished_at - attendance.started_at) / 3600
      return sprintf("%.2f", day_working_calc)
    end
  end
end
