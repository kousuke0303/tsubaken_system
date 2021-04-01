class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :current_matter
  helper_method :current_estimate_matter
  helper_method :self_manager
  helper_method :self_staff
  helper_method :self_external_staff

  # 利用者情報
  def login_user
    return current_admin if current_admin
    return current_manager if current_manager 
    return current_staff if current_staff 
    return current_external_staff if current_external_staff 
    return current_client if current_client
  end
  
  def self_manager
    if @manager.present? && @manager == current_manager
      current_manager
    else
      false
    end
  end
  
  def self_staff
    if @staff.present? && @staff == current_staff
      current_staff
    else
      false
    end
  end
  
  def self_external_staff
    if @external_staff.present? && @external_staff == current_external_staff
      current_external_staff
    else
      false
    end
  end
  
  # --------------------------------------------------------
        # DEVISE関係
  # --------------------------------------------------------
  
  # ログイン後のリダイレクト先
  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(Admin)
      admins_top_path
    elsif resource_or_scope.is_a?(Manager)
      managers_top_path
    elsif resource_or_scope.is_a?(Staff)
      staffs_top_path
    elsif resource_or_scope.is_a?(ExternalStaff)
      external_staffs_top_path
    elsif resource_or_scope.is_a?(Client)
      clients_top_path
    else
      root_path
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email])
  end
  
  # 変更時PASS不要
  def update_resource(resource, params)
    resource.update_without_password(params)
  end
  
  
  #-------------------------------------------------------
      # アクセス制限
  #------------------------------------------------------
  
  # AdminとManager以外はアクセス制限
  def authenticate_admin_or_manager!
    redirect_to root_url unless current_admin || current_manager
  end

  # 従業員以外はアクセス制限
  def authenticate_employee!
    redirect_to root_url unless current_admin || current_manager || current_staff || current_external_staff
  end
  
  def authenticate_admin_or_self_manager!
    if current_admin
      editable = true
    elsif current_manager == @manager
      editable = true
    else
      editable = false
    end
    redirect_to root_url if editable == false
  end
    
  
  # 自分の担当している案件のみアクセス可能（staff_extrnal_staff）
  def can_access_only_of_member(object)
    unless current_admin || current_manager
      if object.member_codes.ids.include?(login_user.member_code)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    end
  end
  
  # ログインstaff以外のページ非表示
  def not_current_staff_return_login!
    unless params[:id].to_i == current_staff.id || params[:staff_id].to_i == current_staff.id
      flash[:alert] = "アクセス権限がありません。"
      redirect_to root_path
    end
  end
  
  # ---------------------------------------------------------
        # FORMAT関係
  # ---------------------------------------------------------

  # login画面等のデザインformat指定
  def non_approval_layout
    @type = "log_in"
  end
  
  def other_tab_display
    @type = "other_tab"
  end
  
  def preview_display
    @type = "preview"
  end

  # ---------------------------------------------------------
        # 日付取得関係　matter/ganttchart attendance
  # ---------------------------------------------------------
  
  def set_one_month
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date.beginning_of_month
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day]
  end

  # ---------------------------------------------------------
        # ATTENDANCE関係
  # ---------------------------------------------------------

  def set_today_attendance(employee)
    @attendance = employee.attendances.where(worked_on: Date.current).first
  end
  
  # Attendance用、マネージャー・スタッフ・外部スタッフ、それぞれの一月分勤怠レコードを生成
  def create_monthly_attendances(resource)
    @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless @attendances.length == @one_month.length
      ActiveRecord::Base.transaction do
        @one_month.each { |day| resource.attendances.create!(worked_on: day) }
      end
      @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  rescue ActiveRecord::RecordInvalid 
    flash[:alert] = "勤怠情報の取得に失敗しました。"
    redirect_to root_url
  end
  
  def employee_attendance_notification
    yesterday = Date.current - 1
    @error_attendances = Attendance.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
  end
  
  def own_attendance_notification
    yesterday = Date.current - 1
    if current_staff
      @own_error_attendances = current_staff.attendances.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
    elsif current_external_staff
      @own_error_attendances = current_external_staff.attendances.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
    end
  end
  
  # --------------------------------------------------------
        # MATTER関係
  # --------------------------------------------------------
  
  def current_matter
    Matter.find_by(id: params[:matter_id]) || Matter.find_by(id: params[:id])
  end
  
  def matter_default_task_requests
    if current_admin || current_manager
      @matter_default_task_scaffolding_requests = Matter.joins(:tasks)
                                                        .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                        .where("tasks.title = ?", "足場架設依頼")
    elsif current_staff
      @matter_default_task_scaffolding_requests = current_staff.matters.joins(:tasks)
                                                                       .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                                       .where("tasks.title = ?", "足場架設依頼")
    elsif current_external_staff
      @matter_default_task_scaffolding_requests = current_external_staff.matters.joins(:tasks)
                                                                                .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                                                .where("tasks.title = ?", "足場架設依頼")
    end
    
    if current_admin || current_manager
      @matter_default_task_order_requests = Matter.joins(:tasks)
                                                  .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                  .where("tasks.title = ?", "発注依頼")
    elsif current_staff
      @staff_matter_default_task_scaffolding_requests = current_staff.matters.joins(:tasks)
                                                                             .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                                             .where("tasks.title = ?", "発注依頼")
    elsif current_external_staff
      @external_staff_matter_default_task_scaffolding_requests = current_external_staff.matters.joins(:tasks)
                                                                                               .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
                                                                                               .where("tasks.title = ?", "発注依頼")
    end
  end
  
  # --------------------------------------------------------
        # ESTIMATE_MATTER関係
  # --------------------------------------------------------

  def current_estimate_matter
    EstimateMatter.find_by(id: params[:estimate_matter_id]) || EstimateMatter.find_by(id: params[:id])
  end
  
  # 見積案件を担当しているユーザーのみアクセス可能
  def can_access_only_estimate_matter_of_being_in_charge
    if current_staff && (params[:id].present? || params[:estimate_matter_id].present?)
      unless params[:id].to_s.in?(current_staff.estimate_matters.ids) || params[:estimate_matter_id].to_s.in?(current_staff.estimate_matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    elsif current_external_staff && (params[:id].present? || params[:estimate_matter_id].present?)
      unless params[:id].to_s.in?(current_external_staff.estimate_matters.ids) || params[:estimate_matter_id].to_s.in?(current_external_staff.estimate_matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    elsif current_client && (params[:id].present? || params[:estimate_matter_id].present?)
      unless params[:id].to_s.in?(current_client.estimate_matters.ids) || params[:estimate_matter_id].to_s.in?(current_client.estimate_matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    end
  end

  # --------------------------------------------------------
        # TASK関係
  # --------------------------------------------------------

  # 案件の持つタスクを分類、sort_orderを連番にupdateして定義
  def set_classified_tasks(resource)
    @default_tasks = Task.are_default
    Task.reload_sort_order(@default_tasks)
    
    @relevant_tasks = resource.tasks.are_relevant
    Task.reload_sort_order(@relevant_tasks)
    
    @ongoing_tasks = resource.tasks.are_ongoing
    Task.reload_sort_order(@ongoing_tasks)
    
    @finished_tasks = resource.tasks.are_finished
    Task.reload_sort_order(@finished_tasks)
  end
  
  def scaffolding_and_order_requests_relevant_or_ongoing
    if current_admin || current_manager
      @scaffolding_and_order_requests_relevant_or_ongoing = Task.where("(title = ?) OR (title = ?)", "足場架設依頼", "発注依頼")
                                                                .where("(status = ?) OR (status = ?)", 1, 2)
    else
      @staff_scaffolding_and_order_requests_relevant_or_ongoing = login_user.member_code.matters.joins(:tasks)
                                                                                                .where("(tasks.title = ?) OR (tasks.title = ?)", "足場架設依頼", "発注依頼")
                                                                                                .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)                                                                     .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
    end
  end
  
  # --------------------------------------------------------
        # SCHDULE関係
  # --------------------------------------------------------
  
  def schedule_application
    @applicate_schedules = Schedule.edit_applications
  end
  
  
  # ---------------------------------------------------------
        # STAFF関係
  # ---------------------------------------------------------

  def set_label_colors
    @label_colors = LabelColor.order(position: :asc)
  end
  
  def set_departments
    @departments = Department.order(position: :asc)
  end
  
  #--------------------------------------------------------
      # NOTIFICATION関係
  #-------------------------------------------------------
  
  def set_notifications(login_user)
    @notifications = login_user.recieve_notifications
    @creation_notification_for_schedule = @notifications.creation_notification_for_schedule
    @updation_notification_for_schedule = @notifications.updation_notification_for_schedule
    @delete_notification_for_schedule = @notifications.delete_notification_for_schedule
  end
  
end
