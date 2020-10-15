class Managers::AttendancesController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_one_month
  
  def index
  end

  def update
  end
end
