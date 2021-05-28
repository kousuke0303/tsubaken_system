class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :alert_tasks, only: :top
  before_action :employee_attendance_notification, only: :top
  before_action :schedule_application, only: :top
  before_action :password_condition_user, only: [:top, :default_password_user_index]

  def top
    set_my_tasks
    set_no_member_tasks(@tasks, @finished_matter_ids, @constraction_estimate_matters_ids)
    set_notifications
  end
  
  def default_password_user_index
  end
  
  def avator_change
    current_admin.avator.attach(params[:avator])
    redirect_to edit_admin_registration_url(current_admin)
  end
  
  def avator_destroy
    current_admin.avator.purge_later
    redirect_to edit_admin_registration_url(current_admin)
  end
  
  private
  
    def password_condition_user
      @object_member_code_array = []
      Manager.includes(:member_code).each do |manager|
        if manager.password_condition == false
          @object_member_code_array << manager.member_code.id
        end
      end
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
