class Staffs::StaffsController < ApplicationController
  before_action :authenticate_staff!
  # before_action :not_current_staff_return_login! 
  before_action :set_one_month
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  before_action ->{ create_monthly_attendances(current_staff) }
  before_action ->{ set_today_attendance(current_staff) }
  before_action :own_attendance_notification, only: :top

  def top
  end
  
  def avator_change
    current_staff.avator.attach(params[:admin_avator])
    redirect_to edit_staff_registration_url(current_staff)
  end
  
  def avator_destroy
    current_staff.avator.purge_later
    redirect_to edit_staff_registration_url(current_staff)
  end
  
  private 
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end

end
