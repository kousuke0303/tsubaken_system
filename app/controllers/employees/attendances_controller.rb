class Employees::AttendancesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_one_month, only: :individual

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
    @attendances = Attendance.where(manager_id: !nil)
  end
end
