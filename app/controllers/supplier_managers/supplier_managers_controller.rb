class SupplierManagers::SupplierManagersController < ApplicationController
  before_action :authenticate_supplier_manager!
  before_action :set_one_month
  before_action :matter_default_task_requests, only:[:index]
  before_action :alert_tasks, only: [:top, :index]
  before_action ->{ create_monthly_attendances(current_supplier_manager) }
  before_action ->{ set_today_attendance(current_supplier_manager) }
  before_action :own_attendance_notification, only: :top
  
  
  def top
    set_notifications
    construction_schedules_for_today
    @construction_schedules = ConstructionSchedule.where(supplier_id: current_supplier_manager.supplier.id)
                                                  .where('construction_schedules.scheduled_finished_on >= ? and ? >= construction_schedules.scheduled_started_on', Date.current, Date.current.next_month.end_of_month)
    set_my_tasks
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
