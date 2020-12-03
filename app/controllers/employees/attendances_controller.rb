class Employees::AttendancesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_one_month, only: :individual
  before_action :set_latest_30_year, only: :individual
  before_action :set_employees, only: [:daily, :individual]
  before_action :set_new_attendance, only: [:daily, :individual]
  before_action :set_attendance, only: [:update, :destroy]

  # 日別勤怠表示ページ
  def daily
    # 対象日を定義
    params[:day] && params[:day].present? ? @day = params[:day].to_date : @day = Date.current
    # 勤怠モデルと、マネージャー・スタッフ・外部スタッフ(所属の外注先を含めて)を事前に読み込む
    attendances = Attendance.where(worked_on: @day).where.not(started_at: nil).includes(:manager).includes(:staff).includes(external_staff: :supplier)
    @manager_attendances = attendances.where.not(manager_id: nil)
    @staff_attendances = attendances.where.not(staff_id: nil)
    @external_staff_attendances = attendances.where.not(external_staff_id: nil)
  end

  # 従業員別の月毎の勤怠表示ページ
  def individual
    if params[:year] && params[:year].present? && params[:month] && params[:month].present?
      @first_day = "#{params[:year]}-#{params[:month]}-01".to_date
      @last_day = @first_day.end_of_month
    end
    if params[:type] && params[:type] == "1" && params[:manager_id] && params[:manager_id].present?
      manager_id = params[:manager_id]
      @resource = Manager.find(manager_id)
    elsif params[:type] && params[:type] == "2" && params[:staff_id] && params[:staff_id].present?
      staff_id = params[:staff_id]
      @resource = Staff.find(staff_id)
    elsif params[:type] && params[:type] == "3" && params[:external_staff_id] && params[:external_staff_id].present?
      external_staff_id = params[:external_staff_id]
      @resource = ExternalStaff.find(external_staff_id)
    end
    @attendances = @resource.attendances.where(worked_on: @first_day..@last_day).where.not(started_at: nil).order(:worked_on) if @resource
  end

  def new
    @attendance = Attendance.new
    @managers = Manager.all
    @staffs = Staff.all
    @external_staffs = ExternalStaff.all
    @prev_action = params[:prev_action]
  end

  def create
    case params[:attendance]["employee_type"]
    when "1"
      manager_id = params[:attendance]["manager_id"]
      resource = Manager.find(manager_id)
    when "2"
      staff_id = params[:attendance]["staff_id"]
      resource = Staff.find(staff_id)
    when "3"
      external_staff_id = params[:attendance]["external_staff_id"]
      resource = ExternalStaff.find(external_staff_id)
    end
    create_monthly_attendance_by_date(resource, params[:attendance]["worked_on"].to_date)
    if @attendance.update(employee_attendance_params)
      flash[:success] = "勤怠を作成しました。"
      if params["prev_action"].eql?("daily")
        redirect_to daily_employees_attendances_url
      else 
        redirect_to individual_employees_attendances_url
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def update
    if @attendance.update(employee_attendance_params.except(:worked_on, :manager_id, :staff_id, :external_staff_id))
      flash[:success] = "勤怠を更新しました。"
      if params["prev_action"].eql?("daily")
        redirect_to daily_employees_attendances_url
      else 
        redirect_to individual_employees_attendances_url
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @attendance.update(started_at: nil, finished_at: nil, working_minutes: nil) ? flash[:success] = "勤怠を削除しました。" : flash[:notice] = "勤怠を削除できませんでした。"
    if params["prev_action"].eql?("daily")
      redirect_to daily_employees_attendances_url
    else 
      redirect_to individual_employees_attendances_url
    end
  end

  private
    # 直近30年をhashに(フォーム用)
    def set_latest_30_year
      @years_hash = Hash.new
      latest_year = @first_day.year
      [*latest_year - 30..latest_year].each { |year| @years_hash.store("#{year}年", year) }
      @years_hash = @years_hash.sort.reverse.to_h
    end

    def set_employees
      @managers = Manager.all
      @staffs = Staff.all
      @external_staffs = ExternalStaff.all
    end

    def set_new_attendance
      @attendance = Attendance.new
    end

    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    def employee_attendance_params
      params.require(:attendance).permit(:employee_type, :manager_id, :staff_id, :external_staff_id, :worked_on, :started_at, :finished_at)
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
      flash[:alert] = "ページ情報の取得に失敗しました。"
      redirect_to root_url
    end
end
