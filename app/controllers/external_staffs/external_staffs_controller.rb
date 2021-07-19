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
    redirect_to edit_external_staff_registration_url
  end
  
  def pass_update
    @external_staff = current_external_staff
    if current_external_staff.update(external_staff_pass_params)
      bypass_sign_in(current_external_staff)
      flash[:success] = "パスワードを更新しました"
      redirect_to edit_external_staff_registration_url
    else
      flash.now[:alert] = "パスワード更新に失敗しました"
      @error_type = "pass"
      render "external_staffs/registrations/edit"
    end
  end
  
  private
    def external_staff_pass_params
      params.require(:external_staff).permit(:password, :password_confirmation)
    end
  
end
