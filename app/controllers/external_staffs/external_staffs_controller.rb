class ExternalStaffs::ExternalStaffsController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_one_month
  before_action ->{ create_monthly_attendances(current_external_staff) }
  before_action ->{ set_today_attendance(current_external_staff) }
  
  def top
  end
end
