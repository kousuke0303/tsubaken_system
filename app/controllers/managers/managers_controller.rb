class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!, only: :top
  before_action :schedule_application, only: :top
  before_action :set_one_month, only: :top
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only: :top
  before_action ->{ create_monthly_attendances(current_manager) }, only: :top
  before_action ->{ set_today_attendance(current_manager) }, only: :top
  before_action :employee_attendance_notification, only: :top
  before_action :authenticate_admin_or_self_manager!, only: [:avator_change, :avator_destroy]
  before_action :target_manager, only: [:avator_change, :avator_destroy]
  before_action :password_condition_user, only: [:top, :default_password_user_index]
  
  def top
    set_notifications(current_manager)
  end
  
  def default_password_user_index
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
    
    def password_condition_user
      @object_member_code_array = []
      Staff.includes(:member_code).each do |staff|
        if staff.password_condition == false
          @object_member_code_array << staff.member_code.id
        end
      end
      ExternalStaff.includes(:member_code).each do |ex_staff|
        if ex_staff.password_condition == false
          @object_member_code_array << ex_staff.member_code.id
        end
      end
      @object_member_code = MemberCode.where(id: @object_member_code_array)
    end
end
