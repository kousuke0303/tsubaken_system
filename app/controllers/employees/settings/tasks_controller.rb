class Employees::Settings::TasksController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_employees_settings_tasks

  def index
    @tasks = Task.are_default_tasks
  end

  def create
  end

  def update
  end

  def destroy
  end

  def set_employees_settings_tasks
    @employees_settings_tasks = "mployees_settings_tasks"
  end
end
