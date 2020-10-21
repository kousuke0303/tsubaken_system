class Employees::AttendancesController < ApplicationController
  before_action :authenticate_admin_or_manager!

  def index
  end
end
