class Staff::MattersController < ApplicationController
  before_action :authenticate_staff!
  before_action :not_current_staff_return_login!
  
  def index
    @progress_matters = current_staff.matters.where.not(status: "finish")
    @finished_matters = current_staff.matters.where(status: "finish")
  end
  
  def show
  end
  
end
