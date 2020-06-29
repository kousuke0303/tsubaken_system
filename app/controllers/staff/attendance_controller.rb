class Staff::AttendanceController < ApplicationController

  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"

  def show

  end

  def update
    @attendance = Attendance.where(staff_id:current_staff.id).find_by(worked_on: Date.today)
    if @attendance.nil?
      if Attendance.create!(submanager_id: 1, staff_id: current_staff.id, worked_on: Date.today, started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(worked_on: Date.today, finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to top_staff_path(current_staff)
  end

  def create
    
  end

  def edit

  end


  private

  def attendances_params
    params.permit(attendances: [:worked_on, :started_at, :finished_at])
  end

  def set_staff
    @staff = Staff.find(params[:id])
  end

end
