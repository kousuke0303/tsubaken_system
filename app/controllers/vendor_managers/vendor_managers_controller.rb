class VendorManagers::VendorManagersController < ApplicationController
  before_action :authenticate_vendor_manager!
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
  
  def pass_update
    @vendor_manager = current_vendor_manager
    @vendor = @vendor_manager.vendor
    @industries = Industry.order(position: :asc)
    if @vendor_manager.update(pass_params)
      bypass_sign_in(@vendor_manager)
      flash[:success] = "パスワードを更新しました"
      redirect_to edit_vendor_manager_registration_path
    else
      flash.now[:alert] = "パスワード更新に失敗しました"
      @error_type = "pass"
      render "vendor_managers/registrations/edit"
    end
  end
  
  private
    def pass_params
      params.require(:vendor_manager).permit(:password, :password_confirmation)
    end
end
