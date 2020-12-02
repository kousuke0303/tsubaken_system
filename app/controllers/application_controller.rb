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
    @first_day = params[:date].nil? ? Date.current.beginning_of_month : params[:date].to_date.beginning_of_month
    @last_day = @first_day.end_of_month
    @one_month = [*@first_day..@last_day]
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

  def set_today_attendance(employee)
    @attendance = employee.attendances.where(worked_on: Date.current).first
  end
  
  # --------------------------------------------------------
        # MATTER関係
  # --------------------------------------------------------
  
  def current_matter
    Matter.find_by(id: params[:matter_id]) || Matter.find_by(id: params[:id])
  end
  
  # --------------------------------------------------------
        # TASK関係
  # --------------------------------------------------------

  # 見積案件・案件の持つタスクを分類、sort_orderを連番にupdateして定義
  def set_classified_tasks(resource)
    @default_tasks = Task.default.order(default_task_id_count: :desc)
    Task.reload_sort_order(@default_tasks)
    @relevant_tasks = resource.tasks.are_relevant
    Task.reload_sort_order(@relevant_tasks)
    @ongoing_tasks = resource.tasks.are_ongoing
    Task.reload_sort_order(@ongoing_tasks)
    @finished_tasks = resource.tasks.are_finished
    Task.reload_sort_order(@finished_tasks)
  end
    
  private
  
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
    redirect_to root_url unless current_admin || current_manager || current_staff
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys:[:email])
  end
end
