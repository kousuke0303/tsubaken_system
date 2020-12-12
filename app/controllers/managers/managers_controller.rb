class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_one_month
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  before_action ->{ create_monthly_attendances(current_manager) }
  before_action ->{ set_today_attendance(current_manager) }
  before_action :attendance_notification
  
  
  def top
  end
end
