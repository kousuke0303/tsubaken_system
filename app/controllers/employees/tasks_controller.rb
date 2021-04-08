class Employees::TasksController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_task

  def edit
  end
  
  def change_status
    @task.update(status: params[:status].to_i)
    set_tasks
  end
  
  def registor_member
  end
  
  def update_member
    @task.sender = login_user.member_code.id
    set_attr_variable
    if @task.update(task_params)
      set_tasks
      set_notifications
    end
  end

  private
    # paramsで送られてきたstatusをenumの数値に変換
    def convert_to_status_num(status)
      case status
      when "default-tasks"
        0
      when "relevant-tasks"
        1
      when "ongoing-tasks"
        2
      when "finished-tasks"
        3
      end
    end
    
    def task_params
      params.require(:task).permit(:title, :content, :deadline, :member_code_id)
    end
    
    def set_attr_variable
      if @task.member_code_id == nil && params[:task][:member_code_id].present?
        @task.notification_type = "create"
      elsif @task.member_code_id != params[:task][:member_code_id].to_i
        @task.notification_type = "create_destroy"
        @task.before_member_code = @task.member_code_id
        @task.before_title = @task.title
      elsif @task.member_code_id == params[:task][:member_code_id].to_i
        @task.notification_type = "update"
        @task.before_title = @task.title
        @task.before_content = @task.content
      end
    end
    
end
