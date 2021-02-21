class ExternalStaffs::ExternalStaffsController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_one_month
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  before_action ->{ create_monthly_attendances(current_external_staff) }
  before_action ->{ set_today_attendance(current_external_staff) }
  before_action :own_attendance_notification, only: :top
  
  def top
  end
  
  def avator_change
    current_external_staff.avator.attach(params[:admin_avator])
    redirect_to edit_external_staff_registration_url(current_external_staff)
  end
  
  def avator_destroy
    current_external_staff.avator.purge_later
    redirect_to edit_external_staff_registration_url(current_external_staff)
  end
end
