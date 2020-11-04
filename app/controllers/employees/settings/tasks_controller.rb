class Employees::Settings::TasksController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_employees_settings_tasks, only: :index
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.are_default
    @task = Task.new
  end

  def create
    task = Task.new(default_task_params.merge(status: 0))
    if task.save
      flash[:success] = "デフォルトタスクを作成しました。"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @task.update(default_task_params)
      flash[:success] = "デフォルトタスクを更新しました。"
      redirect_to employees_settings_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @task.destroy ? flash[:success] = "デフォルトタスクを削除しました。" : flash[:alert] = "デフォルトタスクを削除できませんでした。"
    redirect_to employees_settings_tasks_url
  end

  private
    def set_employees_settings_tasks
      @employees_settings_tasks = "employees_settings_tasks"
    end

    def default_task_params
      params.require(:task).permit(:name, :content)
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
