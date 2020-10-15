class Staffs::AttendancesController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_one_month

  def index
  end

  def update
  end
end
