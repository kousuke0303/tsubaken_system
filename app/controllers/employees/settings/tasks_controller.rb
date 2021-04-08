class Employees::Settings::TasksController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_task, only: [:edit, :update, :destroy]

  def index
    default_tasks = Task.are_default
    @individual_tasks = default_tasks.individual
    @estimate_matter_tasks = default_tasks.estimate_matter
    @matter_tasks = default_tasks.matter
  end

  def new
    @task = Task.new
  end

  def create
    params[:task][:category] = params[:task][:category].to_i
    sort_order = Task.are_default.length
    @default_task = Task.new(default_task_params.merge(status: 0, sort_order: sort_order))
    if @default_task.save
      flash[:success] = "デフォルトタスクを作成しました。"
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
      params.require(:task).permit(:category, :title, :content, :alert, :auto_set)
    end
end
