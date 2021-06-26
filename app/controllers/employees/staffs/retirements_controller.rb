class Employees::Staffs::RetirementsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_staff
  
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
    if @staff.update(resigned_on: params[:staff][:resigned_on])
      flash[:success] = "退職日を登録しました"
      redirect_to employees_staff_retirements_url(@staff)
    else
      retirement_process_variable
      render "index"
    end
  end
  
  def confirmation_for_destroy
  end
  
  private
    def set_staff_task
      @tasks = @staff.tasks.where.not(status: 3)
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
      @matters = @staff.matters.where.not(status:2)
      @estimate_matters = @staff.estimate_matters.left_joins(:matter).where(matters: {estimate_matter_id: nil})
      set_staff_task
      @schedules = Schedule.where(member_code_id: @staff.member_code.id).where('scheduled_date >= ?', Date.today)
      if @estimate_matters.present?
        @process = 1
      elsif @matters.present?
        @process = 2
      elsif @tasks.present?
        @process = 3
      elsif @schedules.present?
        @process = 4
      else
        @process = 5
      end
    end
      
end
