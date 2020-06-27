class Matter::MatterTasksController < ApplicationController
  
  def move_task
    task = Task.find(remove_str(params[:task]))
    # 案件タスクにまだ登録されていない場合は紐付け
    unless current_matter.matter_tasks.where(task_id: task.id).exists?
      current_matter.matter_tasks.create(task_id: task.id)
    end
    task.update(status: params[:status], row_order: roworder_params)
    matter_task_type
    respond_to do |format|
      format.js
    end
  end
  
  def create
    new_task = current_matter.tasks.create(title: params[:title], status: "matter_tasks")
    matter_tasks_count = current_matter.tasks.where(status: "matter_tasks").count
    new_task.update(row_order: matter_tasks_count * 100)
    matter_task_type
    respond_to do |format|
      format.js
    end
  end
  
  def update
    @task = Task.find(params[:id])
    # manager_taskに登録されているものは編集できない
    unless dependent_manager.tasks.where(id: @task.id).exists?
      if @task.update(update_task_params)
        flash.now[:success] = "#{@task.title}を更新しました"
        matter_task_type
        respond_to do |format|
          format.js
        end
      end
    end
  end
  
  def destroy
    @task = Task.find(params[:id])
    # manager_taskに登録されているものは削除できない
    unless dependent_manager.tasks.where(id: @task.id).exists?
      if @task.destroy
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
      params.require(:task).permit(:title, :memo)
    end
    
end
