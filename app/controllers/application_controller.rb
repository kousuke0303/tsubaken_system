class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_submanager_public_uid
  helper_method :current_matter
  helper_method :dependent_manager
  
  # ---------------------------------------------------------
        # FORMAT関係
  # ---------------------------------------------------------
  
  # login画面等のデザインformat指定
  def non_approval_layout
    @type = "log_in"
  end
  
  # ---------------------------------------------------------
        # 日付取得関係　matter/ganttchart attendance
  # ---------------------------------------------------------
  
  def set_one_month
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day]
  end
  
  
  # ---------------------------------------------------------
        # ADMIN関係
  # ---------------------------------------------------------
  
  # 管理者権限者が一人に以上の場合、管理者画面お表示で知らせる。
  def admin_limit_1
    if Admin.count > 1
      @condition = "danger"
    else
      @condition = "dark"
    end
  end
  
  # アクセス制限
  def only_admin!
    unless Admin.first.id == current_admin.id 
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  
  # ---------------------------------------------------------
        # MANAGER関係
  # ---------------------------------------------------------
  
  def dependent_manager
    if manager_signed_in?
      current_manager
    else submanager_signed_in?
      current_submanager.manager
    end
  end
  
  # ログインmanager以外のページ非表示
  def not_current_manager_return_login!
    unless params[:id] == current_manager.public_uid || params[:manager_id] == current_manager.public_uid || params[:manager_public_uid] == current_manager.public_uid
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  # ---------------------------------------------------------
        # SUBMANAGER関係
  # ---------------------------------------------------------
  
  # ログインsubmanager以外のページ非表示
  def not_current_submanager_return_login!
    unless params[:manager_public_uid] == dependent_manager.public_uid
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
    unless params[:id].to_i == current_submanager.id || params[:staff_id].to_i == current_submanager.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  # ---------------------------------------------------------
        # STAFF関係
  # ---------------------------------------------------------
  
  # ログインstaff以外のページ非表示
  def not_current_staff_return_login!
    unless params[:id].to_i == current_staff.id || params[:staff_id].to_i == current_staff.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  # ---------------------------------------------------------
        # USER関係
  # ---------------------------------------------------------
  
  # ログインstaff以外のページ非表示
  def not_current_user_return_login!
    unless params[:id].to_i == current_user.id || params[:user_id].to_i == current_user.id
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  
  # --------------------------------------------------------
        # MATTER関係
  # --------------------------------------------------------
  
  def current_matter
    Matter.find_by(matter_uid: params[:id]) || Matter.find_by(matter_uid: params[:matter_id]) 
  end
  
  def matter_edit_authenticate!
    if current_manager && current_manager.matters.where(matter_uid: params[:id])
      @manager = current_manager
    elsif current_submanager && dependent_manager.matters.where(matter_uid: params[:id])
      @manager = dependent_manager
    else
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_url
    end
  end
  
  def matter_index_authenticate!
    if current_manager && current_manager.public_uid == params[:manager_public_uid]
      @matters = current_manager.matters
    elsif current_submanager && dependent_manager.public_uid == params[:manager_public_uid]
      @matters = dependent_manager.matters
    elsif current_staff
      @matters = current_staff.matters
    else
      flash[:alert] = "アクセス権限がありません"
      redirect_to matter_matters_url(dependent_manager)
    end
  end
  
  def matter_show_authenticate!
    if Matter.find_by(matter_uid: params[:id])
      if current_manager && current_manager.matters.where(matter_uid: params[:id])
        return true
      elsif current_submanager && dependent_manager.matters.where(matter_uid: params[:id])
        return true
      end
    else
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_url
    end
  end
  
  # 自動開始・終了登録
  def create_started_at_or_finished_at
    @tasks = current_matter.tasks
    if @tasks.where(status: "matter_tasks").exists?
      if @tasks.where(status: "progress_tasks").exists? && @tasks.where(status: "finished_tasks").empty?
        progress_tasks = @tasks.where(status: "progress_tasks").order(:move_date)
        first_move_task = progress_tasks.first
        # 既に登録がある場合は、アプデしない
        unless current_matter.started_at.present?
          current_matter.update(started_at: first_move_task.move_date)
        end
      end
    else
      if @tasks.where(status: "progress_tasks").empty? && @tasks.where(status: "finished_tasks").exists?
        complete_tasks = @tasks.where(status: "finished_tasks").order(:move_date)
        last_complete_task = complete_tasks.last
        current_matter.update(finished_at: last_complete_task.move_date)
      end
    end 
  end
  
  # --------------------------------------------------------
        # TASK関係
  # --------------------------------------------------------
  
  # MATTER_TASK______________________________
  
  # 使用回数を保存
  def count_matter_task
    dependent_manager.tasks.each do |task|
      count = Task.where(default_title: task.default_title).where.not(status: nil).count
      task.update(count: count)
    end
  end
  
  # 並び順更新_____________________________________________________
  def reload_row_order(tasks)
    tasks.each_with_index do |task, i|
      task.update(row_order: i * 100)
    end
  end
      
  def matter_task_type
    if manager_signed_in? || submanager_signed_in?
      count_matter_task
      @manager_tasks = dependent_manager.tasks.are_matter_tasks_for_commonly_used
    end
    @matter_tasks = current_matter.tasks.are_matter_tasks
    # row_orderリセット
    reload_row_order(@matter_tasks)
    @matter_progress_tasks = current_matter.tasks.are_progress_tasks
    # row_orderリセット
    reload_row_order(@matter_progress_tasks)
    @matter_complete_tasks = current_matter.tasks.are_finished_tasks
    # row_orderリセット
    reload_row_order(@matter_complete_tasks)
  end
  # __________________________________________________________________
    
  private
  
  # --------------------------------------------------------
        # DEVISE関係
  # --------------------------------------------------------
  
  # ログイン後のリダイレクト先
    def current_submanager_public_uid
      dependent_manager.public_uid
    end
   
  
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        top_admin_admin_path(current_admin)
      elsif resource_or_scope.is_a?(Manager)
        top_manager_path(current_manager)
      elsif resource_or_scope.is_a?(Submanager)
        top_submanager_path(current_submanager_public_uid, current_submanager)
      elsif resource_or_scope.is_a?(Staff)
        top_staff_path(current_staff)
      elsif resource_or_scope.is_a?(User)
        top_user_path(current_user)
      else
        root_path
      end
    end
end
