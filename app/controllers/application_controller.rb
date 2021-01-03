class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_matter
  helper_method :current_estimate_matter

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
    flash[:danger] = "勤怠情報の取得に失敗しました。"
    redirect_to root_url
  end
  
  def employee_attendance_notification
    yesterday = Date.today - 1
    @error_attendances = Attendance.where("(worked_on <= ?)", yesterday)
                                   .where.not(started_at: nil)
                                   .where(finished_at: nil)
  end
  
  def own_attendance_notification
    yesterday = Date.today - 1
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
  
  # 案件を担当しているユーザーのみアクセス可能
  def can_access_only_matter_of_being_in_charge
    if current_staff && (params[:id].present? || params[:matter_id].present?)
      unless params[:id].to_s.in?(current_staff.matters.ids) || params[:matter_id].to_s.in?(current_staff.matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    elsif current_external_staff && (params[:id].present? || params[:matter_id].present?)
      unless params[:id].to_s.in?(current_external_staff.matters.ids) || params[:matter_id].to_s.in?(current_external_staff.matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    end
  end
  
  # --------------------------------------------------------
        # ESTIMATE_MATTER関係
  # --------------------------------------------------------

  def current_estimate_matter
    EstimateMatter.find_by(id: params[:estimate_matter_id]) || EstimateMatter.find_by(id: params[:id])
  end

  # 見積案件の持つ見積カテゴリ、工事、素材を全て取得
  def set_estimates_details(estimate_matter)
    @estimates = estimate_matter.estimates.with_categories
    @materials = Material.of_estimate_matter(estimate_matter.id)
    @constructions = Construction.of_estimate_matter(estimate_matter.id)
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

  # 見積案件・案件の持つタスクを分類、sort_orderを連番にupdateして定義
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
    elsif current_staff
      @staff_scaffolding_and_order_requests_relevant_or_ongoing = current_staff.matters.joins(:tasks)
                                                                                       .where("(tasks.title = ?) OR (tasks.title = ?)", "足場架設依頼", "発注依頼")
                                                                                       .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
    elsif current_external_staff
      @external_staff_scaffolding_and_order_requests_relevant_or_ongoing = current_external_staff.matters.joins(:tasks)
                                                                                                         .where("(tasks.title = ?) OR (tasks.title = ?)", "足場架設依頼", "発注依頼")
                                                                                                         .where("(tasks.status = ?) OR (tasks.status = ?)", 1, 2)
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

  # AdminとManager以外はアクセス制限
  def authenticate_admin_or_manager!
    redirect_to root_url unless current_admin || current_manager
  end

  # 従業員以外はアクセス制限
  def authenticate_employee!
    redirect_to root_url unless current_admin || current_manager || current_staff || current_external_staff
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email])
  end
  
  # ---------------------------------------------------------
        # STAFF関係
  # ---------------------------------------------------------
  
  # ログインstaff以外のページ非表示
  def not_current_staff_return_login!
    unless params[:id].to_i == current_staff.id || params[:staff_id].to_i == current_staff.id
      flash[:alert] = "アクセス権限がありません。"
      redirect_to root_path
    end
  end
end
