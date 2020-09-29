class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!
  # before_action :set_one_month, only: :top
  
  def show
    @manager = Manager.find(current_manager.id)
  end
  
  def top
    @manager = Manager.find(current_manager.id)
  end
  
  def employee
    @staff = dependent_manager.staffs.build
    @staff.manager_staffs.build
  end
  
  def employee_type
    @manager = Manager.find_by(public_uid: params[:id])
    @employee_type = params[:employee_type]
    respond_to do |format|
      format.js
      format.any
    end
  end

  def enduser
    @manager = Manager.find_by(public_uid: params[:id])
  end
end
