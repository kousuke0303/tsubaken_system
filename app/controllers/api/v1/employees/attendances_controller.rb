class Api::V1::Employees::AttendancesController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_resource

  # 従業員自身の一月分の勤怠取得
  def index
    begin
      set_one_month
      api_create_monthly_attendances(@resource)
      render json: { status: "success", message: @attendances }
    end
  rescue
    render json: { status: "false", message: "エラーが発生しました" }
  end

  # 出退勤登録
  def register
    begin
      set_one_month

    end
  rescue
    render json: { status: "false", message: "エラーが発生しました" }
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
    render json: { status: "false", message: "エラーが発生しました" }
  end
end
