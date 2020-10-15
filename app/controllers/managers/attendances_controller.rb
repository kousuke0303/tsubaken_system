class Managers::AttendancesController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_one_month
  before_action ->{ create_month_attendances(current_manager) }
  
  def index
  end

  def update
  end
end
