class Api::V1::Employees::AttendancesController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_resource

  # 従業員自身の一月分の勤怠取得
  def index
    if @resource.is_a?(Manager) || @resource.is_a?(Staff) || @resource.is_a?(ExternalStaff)
      begin
        set_one_month
        api_create_monthly_attendances(@resource)
        render json: @attendances, each_serializer: AttendanceSerializer
      end
    else
      render json: { status: "false", message: "権限が不正です。" }
    end
  rescue
    render json: { status: "false", message: "エラーが発生しました。" }
  end

  # 出退勤登録
  def register
    begin
      set_one_month
      api_create_monthly_attendances(@resource)
      attendance = @resource.attendances.where(worked_on: Date.current).first
      if attendance.started_at.blank? && attendance.finished_at.blank?
        attendance.update!(started_at: Time.current)
        render json: attendance, serializer: AttendanceSerializer
      elsif attendance.finished_at.blank? && attendance.finished_at.blank?
        attendance.update!(finished_at: Time.current)
        render json: attendance, serializer: AttendanceSerializer
      else
        render json: { status: "false", message: "退勤済です。" }
      end
    end
  rescue
    render json: { status: "false", message: "出退勤の登録に失敗しました。" }
  end

  # 従業員自身の@one_monthの勤怠を取得、なければ生成
  def api_create_monthly_attendances(resource)
    @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    unless @attendances.length == @one_month.length
      ActiveRecord::Base.transaction do
        @one_month.each { |day| resource.attendances.create!(worked_on: day) }
      end
      @attendances = resource.attendances.where(worked_on: @first_day..@last_day).order(:worked_on)
    end
  rescue ActiveRecord::RecordInvalid 
    render json: { status: "false", message: "勤怠情報の取得に失敗しました。" }
  end
end
