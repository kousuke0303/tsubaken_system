class Employees::TasksController < ApplicationController
  before_action :set_matter, only: [:create, :move_task]
  before_action :set_default_task, only: [:show, :edit, :update, :destroy, :default_task_update, :default_task_destroy]
  
  def index
    @default_tasks = default_tasks.are_default_tasks
    @default_task = Task.new
  end

  def move_task
    task = Task.find(params[:task])
    new_status = convert_to_status_num(params[:status])
    sort_order = params[:item_index]
    @matter.tasks.where(status: new_status).where("sort_order >= ?", sort_order).each do |task|
      new_sort_order = task.sort_order.to_i + 1
      task.update(sort_order: new_sort_order)
    end
    if task.default?
      # デフォルトタスクからコピー
      @matter.tasks.create(title: task.title, content: task.content, status: new_status, default_task_id: task.id, sort_order: sort_order)
    else
      # タスク移動
      task.update(status: new_status, moved_on: Time.current, before_status: task.status, sort_order: sort_order)
    end
    set_classified_tasks(@matter)
    respond_to do |format|
      format.js
    end
  end
  
  def create
    # 作成前に進行中タスクのsort_orderを更新
    relevant_tasks = @matter.tasks.are_relevant
    Task.reload_sort_order(relevant_tasks)
    # 追加するタスクのsort_orderを定義
    sort_order = relevant_tasks.length
    @matter.tasks.create(title: params[:title], status: 1, sort_order: sort_order)
    set_classified_tasks(@matter)
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @task = Task.find(params[:id])
    # default_tasksに登録されているものは編集できない
    unless default_tasks.where(id: @task.id).exists?
      if @task.update(update_task_params)
        flash[:success] = "#{@task.title}を更新しました。"
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
        flash[:danger] = "#{@task.title}を削除しました。"
        matter_task_type
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  private
    def set_matter
      @matter = Matter.find(params[:matter_id])
    end

    # 文字列から数字のみ取り出す
    def remove_str(str)
      str.gsub(/[^\d]/, "").to_i
    end

    # paramsで送られてきたstatusをenumの数値に変換
    def convert_to_status_num(status)
      case status
      when "default-tasks"
        0
      when "relevant-tasks"
        1
      when "ongoing-tasks"
        2
      when "finished-tasks"
        3
      end
    end
    
    def update_task_params
      params.require(:task).permit(:title, :content)
    end
end
