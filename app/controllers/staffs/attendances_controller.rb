class Staffs::AttendancesController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_one_month
  before_action ->{ create_monthly_attendances(current_staff) }
  before_action ->{ set_today_attendance(current_staff) }
  
  def index
  end

  def update
    if @attendance.started_at.blank? && @attendance.finished_at.blank? && @attendance.update(started_at: Time.now)
      flash[:success] = "出勤しました。"
    elsif @attendance.started_at.present? && @attendance.finished_at.blank? && @attendance.update(finished_at: Time.now)
      flash[:success] = "退勤しました。"
    else
      flash[:success] = "エラーが発生しました。"
    end
    redirect_to staffs_attendances_url
  end
end
