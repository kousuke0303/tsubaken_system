class Employees::ExternalStaffs::RetirementsController < ApplicationController
  before_action :set_external_staff
  before_action :authenticate_admin_or_manager_or_boss!
  
  def index
    retirement_process_variable
  end
  
  def change_member_for_task
    @task = Task.find(params[:task_id])
    @member = @task.member
  end
  
  def update_member_for_task
    @task = Task.find(params[:task_id])
    @task.sender = login_user.member_code.id
    set_task_notification_attr_variable
    if @task.update(task_params)
      retirement_process_variable
    end
  end
  
  def change_member_for_schedule
    @schedule = Schedule.find(params[:schedule_id])
    @member = @schedule.member
  end
  
  def update_member_for_schedule
    @schedule = Schedule.find(params[:schedule_id])
    @schedule.sender = login_user.member_code.id
    set_schedule_notification_attr_variable
    if @schedule.update(schedule_params)
      @responce = "success"
      retirement_process_variable
    else
      @responce = "faliure"
      @target_mamber_name = MemberCode.find(@schedule.member_code_id).parent.name
    end
  end
  
  def resigned_registor
    if @external_staff.update(resigned_on: params[:external_staff][:resigned_on])
      flash[:success] = "退職日を登録しました"
    end
    redirect_to employees_external_staff_retirements_url(@external_staff)
  end
  
  def confirmation_for_destroy
  end
  
  private
    def set_external_staff
      @external_staff = ExternalStaff.find(params[:external_staff_id])
    end
    
    def authenticate_admin_or_manager_or_boss!
      boss = @external_staff.vendor.vendor_manager
      unless current_admin || current_manager || current_vendor_manager == boss
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_url
      end
    end
    
    def set_external_staff_task
      @tasks = @external_staff.tasks.where.not(status: 3)
      @tasks_for_estimate_matter = @tasks.joins(:estimate_matter)
      @tasks_for_matter = @tasks.joins(:matter)
      @tasks_for_individual = @tasks.individual
    end
    
    def set_task_notification_attr_variable
      if @task.member_code_id != params[:task][:member_code_id].to_i
        @task.notification_type = "create_destroy"
        @task.before_member_code = @task.member_code_id
        @task.before_title = @task.title
      end
    end
    
    def set_schedule_notification_attr_variable
      @schedule.before_title = @schedule.title
      if params[:schedule][:member_code_id].to_i != @schedule.member_code_id
        @schedule.before_member_code = @schedule.member_code_id
      end
    end
    
    def task_params
      params.require(:task).permit(:member_code_id)
    end
    
    def schedule_params
      params.require(:schedule).permit(:member_code_id)
    end
    
    def retirement_process_variable
      @matters = @external_staff.matters.where.not(status: 2)
      @construction_schedules = @external_staff.construction_schedules.where.not(status: 2)
      set_external_staff_task
      @schedules = Schedule.where(member_code_id: @external_staff.member_code.id).where('scheduled_date >= ?', Date.today)
      if @matters.present?
        @process = 1
      elsif @construction_schedules.present?
        @process = 2
      elsif @tasks.present?
        @process = 3
      else
        @process = 4
      end
    end
end
