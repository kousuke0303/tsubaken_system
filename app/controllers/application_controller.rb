class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method [:login_user, :current_matter, :current_estimate_matter,
                 :self_manager, :self_staff, :self_external_staff, :self_vendor_manager,
                 :information_present?, :alert_present?]

  # 利用者情報
  def login_user
    return current_admin if current_admin
    return current_manager if current_manager
    return current_staff if current_staff
    return current_vendor_manager if current_vendor_manager
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

  def self_vendor_manager
    @vendor_manager.present? && @vendor_manager == login_user ? current_vendor_manager : false
  end

  # 全MEMBER_CORD
  def all_member_code
    @all_member_codes = MemberCode.all_member_code_of_avaliable
  end
  
  # 自社の従業員
  def employees_member_code
      @member_codes = all_member_code.where(external_staff_id: nil)
                                     .where(vendor_manager_id: nil)
                                     .where(client_id:nil)
  end

  # vendorの全memberコード
  def vendor_members_member_code_ids(vendor)
    vendor.vendor_member_ids
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
    elsif resource_or_scope.is_a?(VendorManager)
      top_vendor_managers_path
    elsif resource_or_scope.is_a?(ExternalStaff)
      external_staffs_top_path
    elsif resource_or_scope.is_a?(Client)
      clients_top_path
    else
      root_path
    end
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
    unless current_admin || current_manager
      sign_out(login_user)
      redirect_to root_path
    end
  end

  # 従業員以外はアクセス制限
  def authenticate_employee!
    unless current_admin || current_manager || current_staff
      sign_out(login_user)
      redirect_to root_path
    end
  end

  def authenticate_admin_or_self_manager!
    if current_admin
      editable = true
    elsif current_manager == @manager
      editable = true
    else
      editable = false
    end
    sign_out(login_user)
    redirect_to root_url if editable == false
  end


  # 自分の担当している案件のみアクセス可能
  def can_access_only_of_member(object)
    unless current_admin || current_manager
      unless object.member_codes.ids.include?(login_user.member_code.id)
        sign_out(login_user)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    end
  end

  # ログインstaff以外のページ非表示
  def not_current_staff_return_login!
    unless params[:id].to_i == current_staff.id || params[:staff_id].to_i == current_staff.id
      sign_out(login_user)
      flash[:alert] = "アクセス権限がありません。"
      redirect_to root_path
    end
  end
  
  # 管理者権限 + vendor_manager
  def authenticate_admin_or_manager_or_In_house_charge(object)
    @boss = object.vendor.vendor_manager
    unless current_admin || current_manager || @boss
      sign_out(login_user)
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_url
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
        # STAFF関係
  # ---------------------------------------------------------

  def set_label_colors
    @label_colors = LabelColor.order(position: :asc)
  end

  def set_departments
    @departments = Department.order(position: :asc)
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


  #--------------------------------------------------------
      # INFORMATION
  #-------------------------------------------------------

  def set_information
    set_notifications
  end

  def information_present?
    true if @uncheck_reports.present? || @notifications.present?
  end

  def set_notifications
    @notifications = login_user.recieve_notifications
    unless current_vendor_manager || current_external_staff
      @creation_notification_for_schedule = @notifications.creation_notification_for_schedule
      @updation_notification_for_schedule = @notifications.updation_notification_for_schedule
      @delete_notification_for_schedule = @notifications.delete_notification_for_schedule
      @creation_notification_for_task = @notifications.creation_notification_for_task
      @updation_notification_for_task = @notifications.updation_notification_for_task
      @delete_notification_for_task = @notifications.delete_notification_for_task
    end
    if current_external_staff || current_vendor_manager
      @creation_notification_for_construction_schedule = @notifications.creation_notification_for_construction_schedule
      @updation_notification_for_construction_schedule = @notifications.updation_notification_for_construction_schedule
      @delete_notification_for_construction_schedule = @notifications.delete_notification_for_construction_schedule
    end
    @creation_notification_for_report = @notifications.creation_notification_for_report
  end

  # --------------------------------------------------------
        # CONSTRUCTION_SCHDULE関係
  # --------------------------------------------------------

  def construction_schedules_for_today
    if current_admin || current_manager
      @construction_schedules_for_today = ConstructionSchedule.includes(:matter, :materials).where('end_date >= ? and ? >= start_date', Date.current, Date.current)
    elsif current_staff
      target_matters_ids = login_user.matters.ids
      @construction_schedules_for_today = ConstructionSchedule.includes(:matter, :materials).where(matter_id: target_matters_ids)
                                                              .where('end_date >= ? and ? >= start_date', Date.current, Date.current)
    elsif current_vendor_manager
      @construction_schedules_for_today = ConstructionSchedule.includes(:matter, :materials, :construction_reports)
                                                              .where(vendor_id: current_vendor_manager.vendor.id)
                                                              .where('end_date >= ? and ? >= start_date', Date.current, Date.current)
    elsif current_external_staff
      @construction_schedules_for_today = ConstructionSchedule.includes(:matter, :materials).where('construction_schedules.end_date >= ? and ? >= construction_schedules.start_date', Date.current, Date.current)
                                                              .where(member_code_id: login_user.member_code.id)
    end
  end

  def construction_schedules_for_calendar(first_day, last_day)
    if current_vendor_manager
      construction_schedules = current_vendor_manager.vendor.construction_schedules
    elsif current_external_staff
      construction_schedules = current_external_staff.construction_schedules
    end
    @construction_schedules = construction_schedules.where(start_date: first_day..last_day).or(construction_schedules.where(end_date: first_day..last_day))
  end

  def construction_schedules_for_matter_calender(matter, first_day, last_day)
    construction_schedules = matter.construction_schedules
    @construction_schedules = construction_schedules.where(start_date: first_day..last_day).or(construction_schedules.where(end_date: first_day..last_day))
  end

  #--------------------------------------------------------
      # ALERT
  #-------------------------------------------------------

  def alert_present?
    alert_tasks
    employee_attendance_notification
    own_attendance_notification
    non_report_construction_schedule

    case login_user
    when current_admin || current_manager
      @alert_result = true if @alert_tasks_count > 0 || @error_attendances.present? || @object_member_code.present? || @no_reports_construction_schedules.present? || login_user.password_condition
    when current_staff
      @alert_result = true if @alert_tasks_count > 0 || @own_error_attendances.present? || login_user.password_condition
    when current_vendor_manager
      @alert_result = true if @alert_tasks_count > 0 || @no_reports_construction_schedules.present? || !login_user.password_condition
    when current_external_staff
      @alert_result = true if @alert_tasks_count > 0 || !login_user.password_condition
    end

  end

  def alert_tasks
    alert_tasks = Task.alert_lists
    if current_admin || current_manager
      @alert_tasks_count = alert_tasks.count
      @alert_tasks_for_matter = alert_tasks.joins(:matter).group_by{ |task| task.default_task_id }
      @alert_tasks_for_estimate_matter = alert_tasks.joins(:estimate_matter).order(:deadline).group_by{ |task| task.default_task_id }
      @alert_tasks_for_individual = alert_tasks.individual.where(member_code_id: login_user.member_code.id).group_by{ |task| task.default_task_id }
    elsif current_staff
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
    elsif current_vendor_manager
      ##### 案件関連タスク(自社のもの)
      # 自社担当の案件のID
      vendor = current_vendor_manager.vendor
      member_ids = vendor_members_member_code_ids(vendor)
      relation_matter_ids = vendor.matters.ids
      alert_tasks_for_matter = alert_tasks.joins(matter: :member_codes)
                                          .where(member_code_id: member_ids)
                                          .where(matters: {id: relation_matter_ids})

      @alert_tasks_for_matter = alert_tasks_for_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_matter_count = alert_tasks_for_matter.count

      # 見積案件関連タスク(自分が担当のもののみ表示)
      relation_estimate_matter_ids = vendor.estimate_matters.ids
      alert_tasks_for_estimate_matter = alert_tasks.joins(estimate_matter: :member_codes)
                                                   .where(member_code_id: member_ids)
                                                   .where(estimate_matters: {id: relation_matter_ids})
      @alert_tasks_for_estimate_matter = alert_tasks_for_estimate_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_estimate_matter_count = alert_tasks_for_estimate_matter.count

      # 個別タスク(自分が担当のもののみ表示)
      alert_tasks_for_individual = alert_tasks.individual.where(member_code_id: login_user.member_code.id)
      @alert_tasks_for_individual = alert_tasks_for_individual.group_by{ |task| task.default_task_id }
      alert_tasks_for_individual_count = alert_tasks_for_individual.count

      @alert_tasks_count = alert_tasks_for_matter_count + alert_tasks_for_estimate_matter_count + alert_tasks_for_individual_count
    elsif current_external_staff
      # 案件関連タスク(自分が担当のもののみ表示)
      alert_tasks_for_matter = alert_tasks.joins(matter: :member_codes)
                                          .where(member_code_id: login_user.member_code.id)
      @alert_tasks_for_matter = alert_tasks_for_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_matter_count = alert_tasks_for_matter.count
      # 見積案件関連タスク(自分が担当のもののみ表示)
      alert_tasks_for_estimate_matter = alert_tasks.joins(estimate_matter: :member_codes)
                                                   .where(member_code_id: login_user.member_code.id)
      @alert_tasks_for_estimate_matter = alert_tasks_for_estimate_matter.group_by{ |task| task.default_task_id }
      alert_tasks_for_estimate_matter_count = alert_tasks_for_estimate_matter.count
      # 個別タスク(自分が担当のもののみ表示)
      alert_tasks_for_individual = alert_tasks.individual.where(member_code_id: login_user.member_code.id)
      @alert_tasks_for_individual = alert_tasks_for_individual.group_by{ |task| task.default_task_id }
      alert_tasks_for_individual_count = alert_tasks_for_individual.count

      @alert_tasks_count = alert_tasks_for_matter_count + alert_tasks_for_estimate_matter_count + alert_tasks_for_individual_count
    end
  end

  def employee_attendance_notification
    yesterday = Date.current.yesterday
    @error_attendances = Attendance.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
  end

  def own_attendance_notification
    yesterday = Date.current.yesterday
    if current_staff
      @own_error_attendances = current_staff.attendances.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
    end
  end

  def non_report_construction_schedule
    if current_admin || current_manager
      @no_reports_construction_schedules = ConstructionSchedule.before_yesterday_work.where(report_count: false)
    elsif current_vendor_manager
      vendor = current_vendor_manager.vendor
      @no_reports_construction_schedules = vendor.construction_schedules.before_yesterday_work.where(report_count: false)
    end
  end

end
