class Staffs::TasksController < Employees::EmployeesController
  before_action :authenticate_staff!
  before_action :set_task, except: [:new, :create]
  
  def new
    @task = Task.new
    @default_tasks = Task.are_default_individual
    @title_content_array = @default_tasks.map{|task| [task.title, task.content]}
  end
  
  def create
    if params[:task][:title].empty?
      params[:task][:title] = Task.find(params[:task][:select_title].to_i).title
    end
    @task = Task.new(task_params.merge(category: 0, status: 1,))
    @task.member_code_id = login_user.member_code.id
    if @task.save
      @responce = "success"
      top_page_variable
    else
      @responce = "failure"
    end
  end
  
  def edit
    @default_tasks = Task.are_default_individual
    @title_content_array = @default_tasks.map{|task| [task.title, task.content]}
  end
  
  def update
    if params[:task][:title].empty?
      params[:task][:title] = Task.find(params[:task][:select_title].to_i).title
    end
    if @task.update(task_params)
      @responce = "success"
      top_page_variable
    else
      @responce = "failure"
    end 
  end
  
  def change_status
    @task.update(status: params[:status].to_i)
    top_page_variable
  end
  
  def destroy
    if @task.destroy
      @responce = "success"
      top_page_variable
    else
      @responce = "failure"
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
      params.require(:task).permit(:title, :content, :deadline, :default_task_id, :member_code_id, :alert)
    end
    
    def set_attr_variable
      if @task.member_code_id != params[:task][:member_code_id].to_i
        @task.notification_type = "create_destroy"
        @task.before_member_code = @task.member_code_id
        @task.before_title = @task.title
      elsif @task.member_code_id == params[:task][:member_code_id].to_i
        @task.notification_type = "update"
        @task.before_title = @task.title
        @task.before_content = @task.content
      elsif @task.member_code_id == nil && params[:task][:member_code_id].present?
        @task.notification_type = "create"
      end
    end
    
    def top_page_variable
      if @task.member_code
        @reciever_notification_count = @task.member_code.recieve_notifications.count
      end
      alert_tasks
      set_my_tasks
      set_notifications
    end
  
end
