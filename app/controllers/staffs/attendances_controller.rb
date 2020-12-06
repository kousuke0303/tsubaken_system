class Staffs::AttendancesController < ApplicationController
  before_action :authenticate_staff!
  
  def index
  end

  def update
    @attendance = current_staff.attendances.find(params[:id])
    if @attendance.started_at.blank? && @attendance.finished_at.blank? && @attendance.update(started_at: Time.now)
      flash[:success] = "出勤しました。"
    elsif @attendance.started_at.present? && @attendance.finished_at.blank? && @attendance.update(finished_at: Time.now)
      flash[:success] = "退勤しました。"
    else
      flash[:success] = "エラーが発生しました。"
    end
    if params[:page] == "top"
      redirect_to staffs_top_url(current_staff)
    else
      redirect_to staffs_attendances_url
    end
  end
end
