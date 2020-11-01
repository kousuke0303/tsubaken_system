class Employees::Settings::TasksController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_employees_settings_tasks
  before_action :set_default_task, only: [:update, :destroy]

  def index
    @task = Task.new
    @tasks = Task.are_default
  end

  def create
    row_order = Task.default.length
    @task = Task.new(default_task_params.merge(status: 0, row_order: row_order))
    if @task.save
      flash[:success] = "デフォルトタスクを作成しました"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @task.update(default_task_params)
      flash[:success] = "デフォルトタスク情報を更新しました"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
  end

  def set_employees_settings_tasks
    @employees_settings_tasks = "mployees_settings_tasks"
  end

  private
    def default_task_params
      params.require(:task).permit(:title, :content)
    end

    def set_default_task
      @task = Task.find(params[:id])
    end
end
