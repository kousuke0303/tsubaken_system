class Employees::AttendancesController < ApplicationController
  before_action :authenticate_admin_or_manager!

  def daily
    params[:day] && params[:day].present? ? @day = params[:day].to_date : @day = Date.current
  end

  def individual
  end
end
