class Manager::AttendancesController < ApplicationController
  before_action :set_one_month, only: :index
  
  def index
    @manager = Manager.find_by(public_uid: params[:id])
    unless params[:employee_type].nil?
      @employee_type = params[:employee_type]
      @split_employee = @employee_type.split('#')
      @employee_name = @split_employee[0]
      @employee_id = @split_employee[1]
      p @employee_name
      p @employee_id
      @submanagers = Submanagers::Attendance.where(submanager_id: @employee_id)
      @staff = Staffs::Attendance.where(staff_id: @employee_id)
    end
    respond_to do |format|
      format.js
      format.any
    end
  end
end
