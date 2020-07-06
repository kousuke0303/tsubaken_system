class Submanager::Settings::TasksController < ApplicationController
  before_action :authenticate_submanager!
  before_action :not_current_submanager_return_login!
  
  def new
    @default_matter_tasks = dependent_manager.tasks
    @matter_task = dependent_manager.tasks
  end
  
  def create
    if dependent_manager.tasks.create(default_task_params.merge(default_title: params[:task][:title]))
      @default_matter_tasks = dependent_manager.tasks
      @task = dependent_manager.tasks.last
      respond_to do |format|
        format.js
      end
    else
    end
  end
  
  def update
    @task = Task.find(params[:id])
    @task.update(default_task_params)
    @default_matter_tasks = dependent_manager.tasks
    respond_to do |format|
      format.js
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    @task.destroy
    flash[:success] = "タスク：#{@task.title}を削除しました"
    redirect_to new_submanager_settings_task_url(dependent_manager)
  end
  
  private
    
    def default_task_params
      params.require(:task).permit(:title, :memo)
    end
end