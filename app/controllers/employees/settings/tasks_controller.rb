class Employees::Settings::TasksController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_employees_settings_tasks, only: :index
  before_action :set_task, only: [:update, :destroy]

  def index
    @tasks = Task.are_default
    @task = Task.new
  end

  def create
  end

  def update
  end

  def destroy
  end

  private
    def set_employees_settings_tasks
      @employees_settings_tasks = "employees_settings_tasks"
    end

    def task_params
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
