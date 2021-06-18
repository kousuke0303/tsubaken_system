class SupplierManagers::SupplierManagersController < ApplicationController
  before_action :authenticate_supplier_manager!
  before_action :matter_default_task_requests, only:[:index]
  before_action :alert_tasks, only: :index
  
  
  def top
    alert_present?
    set_information
    construction_schedules_for_today
    set_my_tasks
  end
  
  def information
    set_information
  end
  
  def avator_change
    current_admin.avator.attach(params[:avator])
    redirect_to edit_admin_registration_url(current_admin)
  end
  
  def avator_destroy
    current_admin.avator.purge_later
    redirect_to edit_admin_registration_url(current_admin)
  end
end
