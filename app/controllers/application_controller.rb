class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :login_user
  helper_method :current_matter
  helper_method :current_estimate_matter
  helper_method :self_manager
  helper_method :self_staff
  helper_method :self_external_staff
  helper_method :self_supplier_manager
  

  # 利用者情報
  def login_user
    return current_admin if current_admin
    return current_manager if current_manager 
    return current_staff if current_staff 
    return current_external_staff if current_external_staff 
    return current_client if current_client
  end
  
  def self_manager
    @manager.present? && @manager == current_manager ? current_manager : false
  end
  
  def self_staff
    @staff.present? && @staff == current_staff ? current_staff : false
  end
  
  def self_external_staff
    @external_staff.present? && @external_staff == current_external_staff ? current_external_staff : false
  end
  
  def self_supplier_manager
    @supplier_manager.present? && @supplier_manager == login_user ? current_supplier_manager : false
  end
  
  # 全MEMBER_CORD
  def all_member_code
    @member_codes = MemberCode.all_member_code_of_avaliable
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
    elsif resource_or_scope.is_a?(SupplierManager)
      supplier_managers_top_path
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
  
  def authenticate_employee_except_external_staff!
    redirect_to root_url unless current_admin || current_manager || current_staff
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
  
  def current_situations_display
    @type = "current_situations"
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
    case resource.class.name
    when "EstimateMatter"
      @default_tasks = Task.are_matter_default_task.estimate_matter
      Task.reload_sort_order(@default_tasks)
    when "Matter"
      @default_tasks = Task.are_matter_default_task.matter
      Task.reload_sort_order(@default_tasks)
    end
    
    @relevant_tasks = resource.tasks.are_relevant
    Task.reload_sort_order(@relevant_tasks)
    
    @ongoing_tasks = resource.tasks.are_ongoing
    Task.reload_sort_order(@ongoing_tasks)
    
    @finished_tasks = resource.tasks.are_finished
    Task.reload_sort_order(@finished_tasks)
  end
  
  def alert_tasks
    if current_admin || current_manager
      alert_tasks = Task.all.alert_lists
      @alert_tasks_count = alert_tasks.count
      @alert_tasks_for_matter = alert_tasks.joins(:matter).group_by{ |task| task.default_task_id }
      @alert_tasks_for_estimate_matter = alert_tasks.joins(:estimate_matter).order(:deadline).group_by{ |task| task.default_task_id }
      @alert_tasks_for_individual = alert_tasks.individual.where(member_code_id: login_user.member_code.id).group_by{ |task| task.default_task_id }
    elsif current_staff || current_external_staff
      alert_tasks = Task.alert_lists
      # 案件関連タスク
      alert_tasks_for_matter = alert_tasks.joins(matter: :member_codes)
                                          .where(matters: { member_codes: { id: login_user.member_code.id } })
      @alert_tasks_for_matter = alert_tasks_for_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_matter_count = alert_tasks_for_matter.count
      # 見積案件関連タスク
      alert_tasks_for_estimate_matter = alert_tasks.joins(estimate_matter: :member_codes)
                                                   .where(estimate_matters: { member_codes: { id: login_user.member_code.id } })
      @alert_tasks_for_estimate_matter = alert_tasks_for_estimate_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_estimate_matter_count = alert_tasks_for_estimate_matter.count
      # 個別タスク
      alert_tasks_for_individual = alert_tasks.individual.where(member_code_id: login_user.member_code.id)
      @alert_tasks_for_individual = alert_tasks_for_individual.group_by{ |task| task.default_task_id }
      alert_tasks_for_individual_count = alert_tasks_for_individual.count
      # 総数
      @alert_tasks_count = alert_tasks_for_matter_count + alert_tasks_for_estimate_matter_count + alert_tasks_for_individual_count
    end
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
  
  def set_my_tasks
    @tasks = Task.joins(:member_code)
    @finished_matter_ids = Matter.completed.ids
    @constraction_estimate_matters_ids = EstimateMatter.for_start_of_constraction.ids
    
    # 完了案件及び着工済み営業案件に紐づくものは除く
    relevant_tasks = @tasks.relevant.where(member_code_id: login_user.member_code.id)
    @relevant_tasks = relevant_tasks.left_joins(:matter, :estimate_matter)
                                    .where.not(matters: {id: @finished_matter_ids})
                                    .where.not(estimate_matters: {id: @constraction_estimate_matters_ids})
                                    .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                    .sort_deadline
    ongoing_tasks = @tasks.ongoing.where(member_code_id: login_user.member_code.id)
    @ongoing_tasks = ongoing_tasks.left_joins(:matter, :estimate_matter)
                                  .where.not(matters: {id: @finished_matter_ids})
                                  .where.not(estimate_matters: {id: @constraction_estimate_matters_ids})
                                  .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                  .sort_deadline
    finished_tasks = @tasks.finished.where(member_code_id: login_user.member_code.id)
    @finished_tasks = finished_tasks.left_joins(:matter, :estimate_matter)
                                    .where.not(matters: {id: @finished_matter_ids})
                                    .where.not(estimate_matters: {id: @constraction_estimate_matters_ids})
                                    .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                    .sort_deadline
  end
  
  def set_no_member_tasks(tasks, finished_matter_ids, constraction_estimate_matters_ids)
    no_member_tasks = Task.all.left_joins(:member_code).where(member_code_id: nil).where.not(status: "default")
    @no_member_tasks = no_member_tasks.left_joins(:matter, :estimate_matter)
                                      .where.not(matters: {id: finished_matter_ids})
                                      .where.not(estimate_matters: {id: constraction_estimate_matters_ids})
                                      .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                      .sort_deadline
    others_relevant_tasks = @tasks.relevant.where.not(member_code_id: login_user.member_code.id)
    @others_relevant_tasks = others_relevant_tasks.left_joins(:matter, :estimate_matter)
                                                  .where.not(matters: {id: finished_matter_ids})
                                                  .where.not(estimate_matters: {id: constraction_estimate_matters_ids})
                                                  .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                                  .sort_deadline
    others_ongoing_tasks = @tasks.ongoing.where.not(member_code_id: login_user.member_code.id)
    @others_ongoing_tasks = others_ongoing_tasks.left_joins(:matter, :estimate_matter)
                                                .where.not(matters: {id: finished_matter_ids})
                                                .where.not(estimate_matters: {id: constraction_estimate_matters_ids})
                                                .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                                .sort_deadline
    others_finished_tasks = @tasks.finished.where.not(member_code_id: login_user.member_code.id)
    @others_finished_tasks = others_finished_tasks.left_joins(:matter, :estimate_matter)
                                                  .where.not(matters: {id: finished_matter_ids})
                                                  .where.not(estimate_matters: {id: constraction_estimate_matters_ids})
                                                  .select('tasks.*, matters.title AS matter_title, estimate_matters.title AS estimate_matter_title')
                                                  .sort_deadline
  end
  
  # --------------------------------------------------------
        # SCHDULE関係
  # --------------------------------------------------------
  
  def schedules_for_today
    @schedules_for_today = Schedule.where(scheduled_date: Date.current, member_code_id: login_user.member_code.id)
  end
  
  def schedule_application
    @applicate_schedules = Schedule.edit_applications
  end
  
  # --------------------------------------------------------
        # CONSTRUCTION_SCHDULE関係
  # --------------------------------------------------------
  
  def construction_schedules_for_today
    if current_admin || current_manager
      @construction_schedules_for_today = ConstructionSchedule.includes(:matter).where('scheduled_finished_on >= ? and ? >= scheduled_started_on', Date.current, Date.current)
    elsif current_staff
      target_matters_ids = login_user.matters.ids
      @construction_schedules_for_today = ConstructionSchedule.where(matter_id: target_matters_ids)
                                                              .where('scheduled_finished_on >= ? and ? >= scheduled_started_on', Date.current, Date.current)
    elsif current_external_staff
      @construction_schedules_for_today = ConstructionSchedule.where(supplier_id: login_user.supplier.id)
                                                              .where('scheduled_finished_on >= ? and ? >= scheduled_started_on', Date.current, Date.current)
    end
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
  
  def set_notifications
    @notifications = login_user.recieve_notifications
    @creation_notification_for_schedule = @notifications.creation_notification_for_schedule
    @updation_notification_for_schedule = @notifications.updation_notification_for_schedule
    @delete_notification_for_schedule = @notifications.delete_notification_for_schedule
    @creation_notification_for_task = @notifications.creation_notification_for_task
    @updation_notification_for_task = @notifications.updation_notification_for_task
    @delete_notification_for_task = @notifications.delete_notification_for_task
  end
  
end
