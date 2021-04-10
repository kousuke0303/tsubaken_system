class Employees::AttendancesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_one_month, only: :individual
  before_action :set_latest_30_year, only: :individual
  before_action :set_employees, only: [:new, :daily, :individual]
  before_action :set_attendance, only: [:edit, :update, :destroy]

  # 日別勤怠表示ページ
  def daily
    # 対象日を定義
    params[:day] && params[:day].present? ? @day = params[:day].to_date : @day = Date.current
    # 勤怠モデルと、マネージャー・スタッフ・外部スタッフ(所属の外注先を含めて)を事前に読み込む
    attendances = Attendance.where(worked_on: @day).start_exist.with_employees
    @manager_attendances = attendances.where.not(member_codes: { manager_id: nil })
    @staff_attendances = attendances.where.not(member_codes: { staff_id: nil })
    @external_staff_attendances = attendances.where.not(member_codes: { external_staff_id: nil })
  end

  # 従業員別の月毎の勤怠表示ページ
  def individual
    if params[:year] && params[:year].present? && params[:month] && params[:month].present?
      @first_day = "#{ params[:year] }-#{ params[:month] }-01".to_date
      @last_day = @first_day.end_of_month
    end
    if params[:type] && params[:type] == "1" && params[:manager_id] && params[:manager_id].present?
      manager_id = params[:manager_id]
      @resource = Manager.find(manager_id).member_code
    elsif params[:type] && params[:type] == "2" && params[:staff_id] && params[:staff_id].present?
      staff_id = params[:staff_id]
      @resource = Staff.find(staff_id).member_code
    elsif params[:type] && params[:type] == "3" && params[:external_staff_id] && params[:external_staff_id].present?
      external_staff_id = params[:external_staff_id]
      @resource = ExternalStaff.find(external_staff_id).member_code
    end
    @attendances = @resource.attendances.where(worked_on: @first_day..@last_day).where.not(started_at: nil).order(:worked_on) if @resource
  end

  def new
    @attendance = Attendance.new
    @prev_action = params[:prev_action]
  end
  
  # 管理者からの勤怠作成
  def create
    if (manager_id = params[:attendance]["manager_id"]).present?
      resource = Manager.find(manager_id).member_code
    elsif (staff_id = params[:attendance]["staff_id"]).present?
      resource = Staff.find(staff_id).member_code
    elsif (external_staff_id = params[:attendance]["external_staff_id"]).present?
      resource = ExternalStaff.find(external_staff_id).member_code
    end
    create_monthly_attendance_by_date(resource, params[:attendance]["worked_on"].to_date)
    if @attendance.update(employee_attendance_params)
      flash[:success] = "勤怠を作成しました"
      if params["prev_action"].eql?("daily")
        redirect_to daily_employees_attendances_url
      else
        redirect_to individual_employees_attendances_url
      end
    end
  end

  def edit
    @prev_action = params[:prev_action]
  end

  def update
    if @attendance.update(employee_attendance_params.except(:worked_on))
      flash[:success] = "勤怠を更新しました"
      params["prev_action"].eql?("daily") ? (redirect_to daily_employees_attendances_url) : (redirect_to individual_employees_attendances_url)
    end
  end

  def destroy
    @attendance.update(started_at: nil, finished_at: nil, working_minutes: nil) ? flash[:success] = "勤怠を削除しました" : flash[:alert] = "勤怠を削除できませんでした"
    params["prev_action"].eql?("daily") ? (redirect_to daily_employees_attendances_url) : (redirect_to individual_employees_attendances_url)
  end

  private
    # 直近30年をhashに(フォーム用)
    def set_latest_30_year
      @years_hash = Hash.new
      latest_year = @first_day.year
      [*latest_year - 30..latest_year].each { |year| @years_hash.store("#{ year }年", year) }
      @years_hash = @years_hash.sort.reverse.to_h
    end

    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def employee_attendance_params
      params.require(:attendance).permit(:worked_on, :started_at, :finished_at)
    end

    def create_monthly_attendance_by_date(resource, date)
      ActiveRecord::Base.transaction do
        unless resource.attendances.where(worked_on: date).exists?
          first_day = date.beginning_of_month
          last_day = first_day.end_of_month
          [*first_day..last_day].each { |day| resource.attendances.create!(worked_on: day) }
        end
        @attendance = resource.attendances.where(worked_on: date).first
      end
    rescue ActiveRecord::RecordInvalid 
      flash[:alert] = "ページ情報の取得に失敗しました"
      redirect_to root_url
    end
end
