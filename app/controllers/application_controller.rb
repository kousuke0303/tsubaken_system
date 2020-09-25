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
    unless params[:manager_id] == current_manager.public_uid || params[:manager_public_uid] == current_manager.public_uid || params[:id] == current_manager.public_uid
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
    unless params[:id].to_i == current_submanager.id || params[:submanager_id].to_i == current_submanager.id
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
    
    # matterにstarted_atが登録されていない場合=>初期登録
    if current_matter.started_at.nil?
    
    # 初期パターン：1 複数の案件タスクの中から進行タスクに移動
      # 案件タスクが少なくとも１つは残っている状態で進行タスクに移動
      # 終了タスクに移動されたものがあるということは初期状態ではないので、除外
      if @tasks.where(status: "matter_tasks").exists? && @tasks.where(status: "progress_tasks").exists? && @tasks.where(status: "finished_tasks").empty?
        progress_tasks = @tasks.where(status: "progress_tasks").order(:move_date)
        first_move_task = progress_tasks.first
        # ここでmatterの状況を更新及びstart_atを登録
        current_matter.update(status: "progress")
        current_matter.update(started_at: first_move_task.move_date)
          
        event_scheduled_start_at = 
          Event.find_by(event_name: "着工予定日",
          event_type: "D",
          manager_id: dependent_manager.id,
          matter_id: current_matter.id)
        if current_matter.scheduled_start_at.present?
          if event_scheduled_start_at.present?
            event_scheduled_start_at.update(event_name: "着工日",event_type: "C",date: first_move_task.move_date)
          else
            Event.create!(event_name: "着工日",
              event_type: "C",
              date: first_move_task.move_date,
              note: "",
              manager_id: dependent_manager.id,
              matter_id: current_matter.id
            )
          end
        else
          if event_scheduled_start_at.present?
            event_scheduled_start_at.destroy
          end
        end
      end
    
    # matterにstarted_atが登録されている場合(2パターンあり)
     # 更新=>誤ってtaskを移動したことにより進行中タスクから案件タスクに戻した場合
     # 完了=>全ての進行タスクが完了タスクに移動された場合
    else
      # 更新パターンの中でさらに２パターンあり
        # 開始日の更新=>進行中タスクへの移動を間違えた場合
        # 完了日の更新=>完了タスクへの移動を間違えた場合
      # 開始日の更新(修正)
      if @tasks.where(status: "matter_tasks").exists? && @tasks.where(status: "progress_tasks").empty? && @tasks.where(status: "finished_tasks").empty?
        current_matter.update(status: "false")
        current_matter.update(started_at: nil)
      # 完了日の更新(修正)
      elsif current_matter.finished_at.present?
        if @tasks.where(status: "matter_tasks").exists? || @tasks.where(status: "progress_tasks").exists?
          current_matter.update(status: "progress")
          current_matter.update(finished_at: nil)
        end
      # 完了パターン
      elsif @tasks.where(status: "matter_tasks").empty? && @tasks.where(status: "progress_tasks").empty? && @tasks.where(status: "finished_tasks").exists?
        complete_tasks = @tasks.where(status: "finished_tasks").order(:move_date)
        last_complete_task = complete_tasks.last
        # ここで完了日を登録
        current_matter.update(finished_at: last_complete_task.move_date, status: "finished")
        current_matter.update(status: "finish")
        
        event_scheduled_finish_at = 
            Event.find_by(event_name: "完了予定日",
            event_type: "D",
            manager_id: dependent_manager.id,
            matter_id: current_matter.id)
        if current_matter.scheduled_finish_at.present?
          if event_scheduled_finish_at.present?
            event_scheduled_finish_at.update(event_name: "完了日",event_type: "C",date: last_complete_task.move_date)
          else
              Event.create!(event_name: "完了日",
                event_type: "C",
                date: last_complete_task.move_date,
                note: "",
                manager_id: dependent_manager.id,
                matter_id: current_matter.id
              )
          end
        else
          if event_scheduled_finish_at.present?
            event_scheduled_finish_at.destroy
          end
        end
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

  # --------------------------------------------------------
        # EVENT関係
  # --------------------------------------------------------

  def manager_event_title
    ary = ManagerEventTitle.where(manager_id: current_manager.id).pluck(:event_name)
    @manager_event_title = Hash.new(0)
      ary.each do |elem|
        @manager_event_title[elem] += 1
      end
    @manager_event_title = @manager_event_title.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h.keys
    return @manager_event_title
  end

  def submanager_event_title
    ary = SubmanagerEventTitle.where(submanager_id: current_submanager.id).pluck(:event_name)
    @submanager_event_title = Hash.new(0)
      ary.each do |elem|
        @submanager_event_title[elem] += 1
      end
    @submanager_event_title = @submanager_event_title.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h.keys
    return @submanager_event_title
  end

  def staff_event_title
    ary = StaffEventTitle.where(staff_id: current_staff.id).pluck(:event_name)
    @staff_event_title = Hash.new(0)
      ary.each do |elem|
        @staff_event_title[elem] += 1
      end
    @staff_event_title = @staff_event_title.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h.keys
    return @staff_event_title
  end
    
  private
  
  # --------------------------------------------------------
        # DEVISE関係
  # --------------------------------------------------------
  
  # ログイン後のリダイレクト先
    def current_submanager_public_uid
      dependent_manager.public_uid
    end
   
  
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Manager)
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
