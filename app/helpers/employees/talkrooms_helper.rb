module Employees::TalkroomsHelper
  
  def my_message?(message)
    
    if admin_signed_in?
      if message.admin_id == current_admin.id
        return true
      else 
        return false
      end
    elsif manager_signed_in?
      if message.manager_id == current_manager.id
        return true
      else
        return false
      end
    elsif staff_signed_in?
      if message.staff_id == current_staff.id
        return true
      else
        return false
      end
    elsif external_staff_signed_in?
      if message.external_staff_id == current_external_staff.id
        return true
      else
        return false
      end
    end
  end
  
  def chat_day_display(date)
    if date == Date.today
      return "今日"
    elsif date == Date.today - 1
      return "昨日"
    else
      return date.strftime("%m/%d")
    end
  end
  
  def current_name
    if admin_signed_in?
      current_admin.name
    elsif manager_signed_in?
      current_manager.name
    elsif staff_signed_in?
      current_staff.name
    elsif external_staff_signed_in?
      current_external_staff.name
    end
  end
  
  def sender_name(message)
    if message.admin_id
      Admin.find_by(id: message.admin_id).name
    elsif message.manager_id
      Manager.find_by(id: message.manager_id).name
    elsif
      Staff.find_by(id: message.staff_id).name
    elsif
      ExternalStaff.find_by(id: message.external_staff_id).name
    end
  end      
end
