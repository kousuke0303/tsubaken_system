class ExternalStaffs::ExternalStaffsController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_one_month
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  before_action ->{ create_monthly_attendances(current_external_staff) }
  before_action ->{ set_today_attendance(current_external_staff) }
  
  def top
  end
end
