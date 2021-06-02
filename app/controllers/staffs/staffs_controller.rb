class Staffs::StaffsController < ApplicationController
  before_action :authenticate_staff!
  before_action :set_one_month
  before_action :alert_tasks, only: :top
  before_action ->{ create_monthly_attendances(current_staff) }
  before_action ->{ set_today_attendance(current_staff) }
  before_action :own_attendance_notification, only: :top

  def top
    set_my_tasks
    set_notifications
    schedules_for_today
    construction_schedules_for_today
  end
  
  def schedule_show
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
