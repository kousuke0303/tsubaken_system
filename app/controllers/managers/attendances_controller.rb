class Managers::AttendancesController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_one_month, only: :index
  
  def index
  end

  def update
    @attendance = current_manager.attendances.find(params[:id])
    if @attendance.started_at.blank? && @attendance.finished_at.blank? && @attendance.update(started_at: Time.now)
      flash[:success] = "出勤しました。"
    elsif @attendance.started_at.present? && @attendance.finished_at.blank? && @attendance.update(finished_at: Time.now)
      flash[:success] = "退勤しました。"
    else
      flash[:success] = "エラーが発生しました。"
    end
    if params[:page] == "top"
      redirect_to managers_top_url(current_manager)
    else
      redirect_to managers_attendances_ur
    end
  end
end
