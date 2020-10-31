class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_manager
  helper_method :current_matter
  helper_method :current_admin
  
  
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

  # Attendance用、マネージャー・スタッフ・外部スタッフ、それぞれの一月分勤怠レコードを生成
  def create_monthly_attendances(resource)
    set_one_month
    @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless @attendances.length == @one_month.length
      ActiveRecord::Base.transaction do
        @one_month.each { |day| resource.attendances.create!(worked_on: day) }
      end
      @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)

    end
  end
  
  # アクセス制限
  def only_admin!
    unless Admin.first.id == current_admin.id 
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end

  # ログインmanager以外のページ非表示
  # def not_current_admin_return_login!
  #   unless params[:manager_id] == current_admin.public_uid || params[:manager_public_uid] == current_admin.public_uid || params[:id] == current_admin.public_uid
  #     flash[:alert] = "アクセス権限がありません"
  #     redirect_to root_path
  #   end
  # end
  
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
    Matter.find_by(id: params[:matter_id]) || Matter.find_by(id: params[:id])
  end
  
  def matter_edit_authenticate!
    if current_admin && current_admin.matters.where(matter_uid: params[:id])
      @manager = current_admin
    else
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_url
    end
  end
  
  # def matter_index_authenticate!
  #   if current_admin && current_admin.public_uid == params[:manager_public_uid]
  #     @matters = current_admin.matters
  #   elsif current_submanager && current_admin.public_uid == params[:manager_public_uid]
  #     @matters = current_admin.matters
  #   elsif current_staff
  #     @matters = current_staff.matters
  #   else
  #     flash[:alert] = "アクセス権限がありません"
  #     redirect_to matter_matters_url(current_admin)
  #   end
  # end
  
  def matter_show_authenticate!
    if Matter.find_by(matter_uid: params[:id])
      if current_admin && current_admin.matters.where(matter_uid: params[:id])
        return true
      elsif current_admin.matters.where(matter_uid: params[:id])
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
        current_matter.update(status: "progress")
        event_scheduled_start_at = 
            Event.find_by(event_name: "着工予定日",
            event_type: "D",
            matter_id: current_matter.id)
        if current_matter.scheduled_start_at.present?
          if event_scheduled_start_at.present?
            event_scheduled_start_at.update(event_name: "着工日",event_type: "C",date: first_move_task.move_date)
          else
              Event.create!(event_name: "着工日",
                event_type: "C",
                date: first_move_task.move_date,
                note: "",
                manager_id: current_admin.id,
                matter_id: current_matter.id
              )
          end
        else
          if event_scheduled_start_at.present?
            event_scheduled_start_at.destroy
          end
        end
        # 既に登録がある場合は、アプデしない
        unless current_matter.started_at.present?
          current_matter.update(started_at: first_move_task.move_date)
        end
      end
    
    # matterにstarted_atが登録されている場合(2パターンあり)
    # 更新=>誤ってtaskを移動したことにより進行中タスクから案件タスクに戻した場合
    # 完了=>全ての進行タスクが完了タスクに移動された場合
    else
      if @tasks.where(status: "progress_tasks").empty? && @tasks.where(status: "finished_tasks").exists?
        complete_tasks = @tasks.where(status: "finished_tasks").order(:move_date)
        last_complete_task = complete_tasks.last
        current_matter.update(finished_at: last_complete_task.move_date, status: "finished")
        event_scheduled_finish_at = 
            Event.find_by(event_name: "完了予定日",
            event_type: "D",
            manager_id: current_admin.id,
            matter_id: current_matter.id)
        if current_matter.scheduled_finish_at.present?
          if event_scheduled_finish_at.present?
            event_scheduled_finish_at.update(event_name: "完了日",event_type: "C",date: last_complete_task.move_date)
          else
              Event.create!(event_name: "完了日",
                event_type: "C",
                date: last_complete_task.move_date,
                note: "",
                manager_id: current_admin.id,
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
  
  def default_tasks
    Task.where.not(default_title: nil).are_default_tasks
  end
  
  # 使用回数を保存
  def count_default_task
    default_tasks.each do |task|
      priority_count = Task.where(default_title: task.default_title).where.not(status: nil).count
      task.update(priority_count: priority_count)
    end
  end
  
  # 並び順更新_____________________________________________________
  def reload_row_order(tasks)
    tasks.each_with_index do |task, i|
      task.update(row_order: i * 100)
    end
  end
      
  def matter_task_type
    if admin_signed_in? || manager_signed_in?
      count_default_task
      @default_tasks = default_tasks.are_default_tasks.are_matter_tasks_for_commonly_used
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
    ary = ManagerEventTitle.where(manager_id: current_admin.id).pluck(:event_name)
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
      current_admin.public_uid
    end
   
  
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        top_admin_path(current_admin)
      elsif resource_or_scope.is_a?(Manager)
        top_manager_path(current_manager)
      elsif resource_or_scope.is_a?(Staff)
        top_staff_path(current_staff)
      elsif resource_or_scope.is_a?(User)
        top_user_path(current_user)
      else
        root_path
      end
    end
end
