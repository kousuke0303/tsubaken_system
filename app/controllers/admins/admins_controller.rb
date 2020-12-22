class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  before_action :employee_attendance_notification

  def top
  end
  
end
