class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only: :top
  before_action :employee_attendance_notification, only: :top
  before_action :schedule_application, only: :top
  

  def top
  end
  
  def avator_change
    current_admin.avator.attach(params[:admin_avator])
    redirect_to edit_admin_registration_url(current_admin)
  end
  
  def avator_destroy
    current_admin.avator.purge_later
    redirect_to edit_admin_registration_url(current_admin)
  end
end
