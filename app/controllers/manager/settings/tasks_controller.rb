class Manager::Settings::TasksController < ApplicationController
  
  before_action :authenticate_manager!
  
  def new
    @default_matter_tasks = current_manager.tasks
    @matter_task = current_manager.tasks
  end
  
  def create
    if current_manager.tasks.create(default_task_params)
      @default_matter_tasks = current_manager.tasks
      @task = current_manager.tasks.last
      respond_to do |format|
        format.js
      end
    else
    end
  end
  
  def update
    @task = Task.find(params[:id])
    @task.update(default_task_params)
    @default_matter_tasks = current_manager.tasks
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = "タスク：#{@task.title}を削除しました"
    redirect_to new_manager_settings_task_url(current_manager)
  end
  
  private
    
    def default_task_params
      params.require(:task).permit(:title, :memo)
    end
end
