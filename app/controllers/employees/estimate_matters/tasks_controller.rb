class Employees::EstimateMatters::TasksController < Employees::TasksController
  before_action :set_estimate_matter
  before_action :set_task, except: [:move, :create]
  before_action ->{ group_for(@estimate_matter) }, only: [:edit, :change_member]
  before_action :set_manager, if: :object_is_manager?, only: [:change_member]
  before_action :set_staff, if: :object_is_staff?, only: [:change_member]
  before_action :target_external_staff, if: :object_is_external_staff?, only: [:change_member]

  def move
    #パラメーターからenum数値抽出
    new_status = Task.statuses[params[:status].to_sym]
    
    @default_tasks = Task.are_default
    # 移動先がデフォルトタスクでない場合のみ処理
    unless new_status == 0
      task = Task.find(params[:task])
      sort_order = params[:item_index].to_i
      # 同ステータス内で上に移動時
      if task.status_before_type_cast == new_status && task.sort_order < sort_order
        # 対象タスクより、優先順位が上のtask_params全タスクのsort_orderを-1
        Task.decrement_sort_order(@estimate_matter, new_status, sort_order)
        task.update(moved_on: Time.current, sort_order: sort_order)
      # ステータス移動、又は下に移動時
      else
        # 対象タスクより、優先順位が下の全タスクのsort_orderを+1
        Task.increment_sort_order(@estimate_matter, new_status, sort_order)
        if task.default?
          # デフォルトタスクからコピー
          @estimate_matter.tasks.create(title: task.title, content: task.content, status: new_status, default_task_id: task.id, sort_order: sort_order)
        else
          # タスク移動
          task.update(status: new_status, moved_on: Time.current, before_status: task.status, sort_order: sort_order)
        end
      end
    end
    set_classified_tasks(@estimate_matter)
  end
  
  def create
    # 作成前に進行中タスクのsort_orderを更新
    relevant_tasks = @estimate_matter.tasks.are_relevant
    Task.reload_sort_order(relevant_tasks)
    # 追加するタスクのsort_orderを定義
    sort_order = relevant_tasks.length
    title = params[:title]
    @estimate_matter.tasks.create(title: title, status: 1, sort_order: sort_order)
    set_classified_tasks(@estimate_matter)
  end

  def edit
  end
  
  def update
    @task.sender = login_user.member_code.id
    set_attr_variable
    set_classified_tasks(@estimate_matter) if @task.update(task_params)
  end
  
  def destroy
    @task.sender = login_user.member_code.id
    if @task.destroy
      flash[:danger] = "タスクを削除しました。"
      unless params[:submit_type] == "change_member"
        set_classified_tasks(@estimate_matter)
      else
        @staff = Staff.find(params[:estimate_matter][:staff_id])
        redirect_to retirement_process_employees_staff_url(@staff)
      end
    end
  end
  
  def change_member
  end
  
  def update_member
    @task.sender = login_user.member_code.id
    set_attr_variable
    set_classified_tasks(@estimate_matter) if @task.update(task_params)
    flash[:success] = "#{@task.title}の担当者を変更しました"
    if params[:task][:manager_id].present?
      @manager = Manager.find(params[:task][:manager_id])
      redirect_to retirement_process_employees_manager_url(@manager)
    elsif params[:task][:staff_id].present?
      @staff = Staff.find(params[:task][:staff_id])
      redirect_to retirement_process_employees_staff_url(@staff)
    elsif params[:task][:external_staff_id].present? 
      @external_staff = ExternalStaff.find(params[:task][:external_staff_id])
      redirect_to retirement_process_employees_external_staff_url(@external_staff)
    end
  end
  
  def change_status
  end
end
