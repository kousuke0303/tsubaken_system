class AlertsController < ApplicationController
  before_action :authenticate_employee!
  before_action :alert_tasks
  
  def index
  end
end
