class Employees::EstimateMatters::TasksController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_task, only: [:edit, :update, :destroy]

  def create
    # 作成前に進行中タスクのsort_orderを更新
    relevant_tasks = @estimate_matter.tasks.are_relevant
    Task.reload_sort_order(relevant_tasks)
    # 追加するタスクのsort_orderを定義
    sort_order = relevant_tasks.length
    title = params[:title]
    @a = @estimate_matter.tasks.create(title: title, status: 1, sort_order: sort_order)
    set_classified_tasks(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  def edit
  end
  
  def update
    if @task.update(task_params)
      set_classified_tasks(@estimate_matter)
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @task.destroy
      flash[:danger] = "タスクを削除しました。"
      set_classified_tasks(@estimate_matter)
      respond_to do |format|
        format.js
      end
    end
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_task
      @task = Task.find(params[:id])
    end
end
