class Employees::AttendancesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_one_month, only: :individual

  def daily
    params[:day] && params[:day].present? ? @day = params[:day].to_date : @day = Date.current
    attendances = Attendance.where(worked_on: @day).includes(:manager).includes(:staff).includes(:external_staff)
    @manager_attendances = attendances.where(manager_id: !nil)
    @staff_attendances = attendances.where(staff_id: !nil)
    @external_staff_attendances = attendances.where(external_staff_id: !nil)
  end

  def individual
    @attendances = Attendance.where(manager_id: !nil)
  end
end
