module ExternalStaffs::ExternalStaffsHelper
  
  def alert_present?(alert_task_count, own_error_attendances)
    if alert_task_count > 0 || own_error_attendances.present? || login_user.password_condition == false
      true
    else
      false
    end
  end
  
  def information_present?(notifications)
    if notifications.present?
      true
    else
      false
    end
  end
end