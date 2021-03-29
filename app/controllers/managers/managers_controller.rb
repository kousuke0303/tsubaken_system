class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!, only: :top
  before_action :set_one_month, only: :top
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only: :top
  before_action ->{ create_monthly_attendances(current_manager) }, only: :top
  before_action ->{ set_today_attendance(current_manager) }, only: :top
  before_action :employee_attendance_notification, only: :top
  before_action :authenticate_admin_or_self_manager!, except: :top
  before_action :target_manager, except: :top
  
  def top
  end
  
  def avator_change
    @manager.avator.attach(params[:avator])
    if self_manager
      redirect_to edit_manager_registration_url(current_manager)
    elsif current_admin
      redirect_to employees_manager_path(@manager)
    end
  end
  
  def avator_destroy
    @manager.avator.purge_later
    if self_manager
      redirect_to edit_manager_registration_url(current_manager)
    elsif current_admin
      redirect_to employees_manager_path(@manager)
    end
  end
  
  private
    def target_manager
      @manager = Manager.find(params[:id])
    end
end
