class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!
  # before_action :set_one_month, only: :top
  
  def top
  end
  
  def employee_type
    @employee_type = params[:employee_type]
    respond_to do |format|
      format.js
      format.any
    end
  end

  def enduser
    @manager = current_manager
  end
end
