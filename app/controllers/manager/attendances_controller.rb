class Manager::AttendancesController < ApplicationController
  before_action :set_one_month
  
  def index
  end
  
  def attendance_search
    params_devide = params[:employee_type].split('#')
    if params_devide[0] == "submanager"
      @type = "submanager"
      @submanager = current_manager.submanagers.find(params_devide[1])
      @attendances = @submanager.attendances.where(worked_on: @first_day..@last_day)
    else
      @type = "staff"
      @staff = current_manager.staffs.find(params_devide[1])
      @attendances = @staff.attendances.where(worked_on: @first_day..@last_day)
    end
    respond_to do |format|
      format.js
    end
  end
  
  def attendance_change_month
    if params[:type] == "submanager"
      @type = "submanager"
      @submanager = current_manager.submanagers.find(params[:target])
      @attendance = @submanager.attendances.where(worked_on: @first_day..@last_day)
    elsif params[:type] == "staff" 
      @type = "staff"
      @staff = current_manager.staffs.find(params[:target])
      @attendance = @staff.attendances.where(worked_on: @first_day..@last_day)
    end
    respond_to do |format|
      format.js
    end  
  end
end
