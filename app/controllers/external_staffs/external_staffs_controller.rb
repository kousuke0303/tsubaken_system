class ExternalStaffs::ExternalStaffsController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :matter_default_task_requests, only:[:index]
  
  def top
    alert_present?
    set_information
    set_my_tasks
    construction_schedules_for_today
    @construction_schedules = ConstructionSchedule.joins(matter: :member_codes)
                                                  .where('construction_schedules.scheduled_finished_on >= ? and ? >= construction_schedules.scheduled_started_on', Date.current, @last_day)
                                                  .where( matters: { member_codes:{ external_staff_id: current_external_staff.id }})
  end
  
  def avator_change
    current_external_staff.avator.attach(params[:avator])
    redirect_to edit_external_staff_registration_url(current_external_staff)
  end
  
  def avator_destroy
    current_external_staff.avator.purge_later
    redirect_to edit_external_staff_registration_url(current_external_staff)
  end
  
end
