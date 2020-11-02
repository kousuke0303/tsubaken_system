class Employees::TasksController < ApplicationController
  before_action :set_default_task, only: [:show, :edit, :update, :destroy, :default_task_update, :default_task_destroy]
  
  def index
    default_tasks
    @default_tasks = default_tasks.are_default_tasks.are_matter_tasks_for_commonly_used
    @default_task = Task.new
  end

  def move_task
    task = Task.find(remove_str(params[:task]))
    before_status = task.status
    move_date = Time.current
    # default_tasksから移動した場合は、コピー作成
    if default_tasks.where(id: task.id).exists?
      copy_task = task.deep_dup
      copy_task.save
      current_matter.tasks.create(status: params[:status], matter_id: current_matter.id, title: task.default_title)
      copy_task.update(status: params[:status], row_order: roworder_params)
    else
      task.update(status: params[:status],
                  before_status: before_status,
                  move_date: move_date,
                  row_order: roworder_params)
    end
    matter_task_type
    respond_to do |format|
      format.js
    end
  end
  
  def create
    if params[:status] == "matter_tasks"
      new_task = current_matter.tasks.create(title: params[:title], status: "matter_tasks")
      matter_tasks_count = current_matter.tasks.where(status: "matter_tasks").count
      new_task.update(row_order: matter_tasks_count * 100)
      matter_task_type
      respond_to do |format|
        format.js
      end
    elsif params[:status] == "default_tasks"
      new_task = default_tasks.create(default_title: params[:default_title], status: "default_tasks")
      default_tasks_count = default_tasks.where(status: "default_tasks").count
      new_task.update(row_order: default_tasks_count * 100)
      matter_task_type
      respond_to do |format|
        format.js
      end
    end
  end
  
  def default_task_create
    @default_task = Task.new(default_title_params)
    if @default_task.save
      flash[:success] = "デフォルトタスクを作成しました"
      redirect_to employees_tasks_url
    else
      flash[:danger] = "デフォルトタスク作成に失敗しました"
      redirect_to employees_tasks_url
    end
  end
  
  def update
    @task = Task.find(params[:id])
    # default_tasksに登録されているものは編集できない
    unless default_tasks.where(id: @task.id).exists?
      if @task.update(update_task_params)
        flash[:success] = "#{@task.title}を更新しました"
        matter_task_type
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  def default_task_update
    if @default_task.update(default_title_params)
      flash[:success] = "デフォルトタスク名を更新しました"
      redirect_to employees_tasks_url
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    # default_tasksに登録されているものは削除できない
    unless default_tasks.where(id: @task.id).exists?
      if @task.destroy
        flash[:danger] = "#{@task.title}を削除しました"
        matter_task_type
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  def default_task_destroy
    @default_task.destroy ? flash[:success] = "デフォルトタスクを削除しました" : flash[:alert] = "デフォルトタスクを削除できませんでした"
    redirect_to employees_tasks_url
  end
  
  private
    # 文字列から数字のみ取り出す
    def remove_str(str)
      str.gsub(/[^\d]/, "").to_i
    end
    
    def roworder_params
      (params[:item_index].to_i * 100 ) - 1
    end
    
    def update_task_params
      params.require(:task).permit(:title, :contents)
    end
    
    def default_title_params
      params.require(:task).permit(:default_title, status: "default_tasks")
    end
    
    def set_default_task
      @default_task = Task.find(params[:id])
    end
end
