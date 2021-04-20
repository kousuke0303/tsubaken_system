class Employees::Managers::RetirementsController < Employees::EmployeesController
  before_action :authenticate_admin!
  before_action :set_manager
  
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
    if @manager.update(resigned_on: params[:manager][:resigned_on])
      flash[:success] = "退職日を登録しました"
    end
    redirect_to employees_manager_retirements_url(@manager)
  end
  
  def confirmation_for_destroy
  end
  
  private
    def set_manager_task
      @tasks = @manager.tasks.where.not(status: 3)
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
      set_manager_task
      @schedules = Schedule.where(member_code_id: @manager.member_code.id).where('scheduled_date >= ?', Date.today)
      if @tasks.present?
        @process = 1
      elsif @schedules.present?
        @process = 2
      else
        @process = 3
      end
    end
end
