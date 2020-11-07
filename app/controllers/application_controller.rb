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
  
  # --------------------------------------------------------
        # MATTER関係
  # --------------------------------------------------------
  
  def current_matter
    Matter.find_by(id: params[:matter_id]) || Matter.find_by(id: params[:id])
  end
  
  # --------------------------------------------------------
        # TASK関係
  # --------------------------------------------------------

  
  # 並び順更新_____________________________________________________
  def reload_sort_order(tasks)
    tasks.each_with_index do |task, i|
      task.update(sort_order: i * 100)
    end
  end

  # 案件の持つタスクを分類して定義
  def set_classified_tasks(matter)
    @default_tasks = Task.are_default
    @relevant_tasks = matter.tasks.are_relevant
    @ongoing_tasks = matter.tasks.are_ongoing
    @finished_tasks = matter.tasks.are_finished
  end
    
  private
  
  # --------------------------------------------------------
        # DEVISE関係
  # --------------------------------------------------------
  
  # ログイン後のリダイレクト先
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

  # AdminとManager以外はアクセス制限
  def authenticate_admin_or_manager!
    redirect_to root_url unless current_admin || current_manager
  end

  # 従業員以外はアクセス制限
  def authenticate_employee!
    redirect_to root_url unless current_admin || current_manager || current_staff
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,keys:[:email])
  end
end
