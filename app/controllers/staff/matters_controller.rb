class Staff::MattersController < ApplicationController
  before_action :authenticate_staff!
  
  def index
    @progress_matters = current_staff.matters.where.not(status: "finish")
    @finished_matters = current_staff.matters.where(status: "finish")
  end
  
  def show
  end
  
end
