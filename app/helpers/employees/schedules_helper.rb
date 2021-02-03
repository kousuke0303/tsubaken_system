module Employees::SchedulesHelper
  
  def schedule_member_name(schedule)
    if schedule.admin_id.present?
      Admin.find(schedule.admin_id).name
    elsif schedule.manager_id.present?
      Manager.find(schedule.manager_id).name
    elsif schedule.staff_id.present?
      Staff.find(schedule.staff_id).name
    elsif schedule.external_staff_id.present?
      ExternalStaff.find(external_staff_id).name
    end
  end
end
