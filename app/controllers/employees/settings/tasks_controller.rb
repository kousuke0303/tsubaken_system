class Employees::Settings::TasksController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    @tasks = Task.are_default
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(default_task_params.merge(status: "default"))
    if @task.save
      flash[:success] = "デフォルトタスクを作成しました"
      redirect_to employees_settings_tasks_url
    end
  end

  def edit
  end

  def update
    if @task.update(default_task_params)
      flash[:success] = "デフォルトタスクを更新しました"
      redirect_to employees_settings_tasks_url
    end
  end

  def destroy
    @task.destroy ? flash[:success] = "デフォルトタスクを削除しました" : flash[:alert] = "デフォルトタスクを削除できませんでした"
    redirect_to employees_settings_tasks_url
  end

  def sort
    from = params[:from].to_i + 1
    task = Task.are_default.find_by(position: from)
    task.insert_at(params[:to].to_i + 1)
    @tasks = Task.are_default
  end

  private
    def default_task_params
      params.require(:task).permit(:title, :content, :alert, :auto_set)
    end
end
