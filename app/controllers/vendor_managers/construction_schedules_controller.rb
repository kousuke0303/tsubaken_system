class VendorManagers::ConstructionSchedulesController < ApplicationController
  before_action :set_construction_schedule, except: :index
  before_action -> {authenticate_admin_or_manager_or_In_house_charge(@construction_schedule)}, except: :index
  before_action :authenticate_vendor_manager!, only: :index

  def index
    @calendar_type = "vendors_schedule"
    if params[:start_date].present?
      @object_day = params[:start_date].to_date
    else
      @object_day = Date.current
    end
    @calendar_span = Span.new
    @calendar_span.simple_calendar(@object_day)
    construction_schedules_for_calendar(@calendar_span.first_day, @calendar_span.last_day)
  end

  def show
    date = params[:day].to_date
    @construction_report = @construction_schedule.construction_reports.find_by(work_date: date)
  end

  def edit
    if current_vendor_manager
      @vendor = current_vendor_manager.vendor
    else
      @vendor = @boss.vendor
    end
    @vendor_staff_codes_ids = @vendor.vendor_member_ids_for_matter_select(@construction_schedule.matter)
    # 退職処理の場合
    if params[:retire_external_staff_id].present?
      @retire_external_staff_id = params[:retire_external_staff_id]
    end
  end

  # 担当者のみ変更可
  def update
    attr_set_for_update
    if @construction_schedule.update(update_params)
      @responce = "success"
      @reciever_notification_count = @construction_schedule.member_code.recieve_notifications.count
      @construction_schedules = @construction_schedule.matter.construction_schedules.includes(:materials).order_start_date
      # 退職処理の場合
      if params[:construction_schedule][:retire_external_staff_id].present?
        @external_staff = ExternalStaff.find(params[:construction_schedule][:retire_external_staff_id])
        redirect_to employees_external_staff_retirements_url(@external_staff)
      end
    end
  end

  def picture
    @construction_schedule_pictures = @construction_schedule.images
  end

  private

    def set_construction_schedule
      @construction_schedule = ConstructionSchedule.find(params[:id])
    end

    def update_params
      params.require(:construction_schedule).permit(:member_code_id)
    end

    def attr_set_for_update
      @construction_schedule.sender = login_user.member_code.id
      @construction_schedule.sender_auth = login_user.auth
      if params[:construction_schedule][:member_code_id].to_i != @construction_schedule.member_code_id
        @construction_schedule.before_member_code = @construction_schedule.member_code_id
      end
    end
end
