class Employees::TasksController < ApplicationController
  before_action :set_default_task, only: [:show, :edit, :update, :destroy, :default_task_update, :default_task_destroy]
  
  def index
    @default_tasks = default_tasks.are_default_tasks
    @default_task = Task.new
  end

  def move_task
    task = Task.find(remove_str(params[:task]))
    before_status = task.status
    moved_on = Time.current
    # default_tasksから移動した場合は、コピー作成
    if default_tasks.where(id: task.id).exists?
      copy_task = task.deep_dup
      copy_task.save
      current_matter.tasks.create(status: params[:status], matter_id: current_matter.id, title: task.default_title)
      copy_task.update(status: params[:status], row_order: roworder_params)
    else
      task.update(status: params[:status],
                  before_status: before_status,
                  moved_on: moved_on,
                  row_order: roworder_params)
    end
    matter_task_type
    respond_to do |format|
      format.js
    end
  end
  
  def create
    @matter = Matter.find(params[:matter_id])
    # 作成前に進行中タスクのsort_orderを更新
    relevant_tasks = @matter.tasks.are_relevant
    Task.rearranges(relevant_tasks)
    # 追加するタスクのsort_orderを定義
    sort_order = relevant_tasks.length
    @matter.tasks.create(title: params[:title], status: 1, sort_order: sort_order)
    respond_to do |format|
      format.js
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
