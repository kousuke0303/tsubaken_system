class VendorManagers::MattersController < ApplicationController
  before_action :authenticate_vendor_manager!
  before_action :set_matter, except: :index
  before_action :set_vendor

  def index
    @matters = current_vendor_manager.matters
    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.where(status: "not_started")
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.where(status: "progress")
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.where(status: "completed")
    end
  end

  def show
    set_matter_detail_valiable
    @client = @matter.client
    @estimate_matter = @matter.estimate_matter
    @message = true if params[:type] == "success"
    @images = @matter.images.select{ |image| image.image.attached? }
    gon.matter_id = @matter.id
    @construction_schedules = @matter.construction_schedules.includes(:materials, :vendor).order_start_date
  end

  def edit
    params[:vendor_id].present? ? @vendor = Vendor.find(params[:vendor_id]) : @vendor = current_vendor_manager.vendor
    @vendor_staff_codes_ids = @vendor.external_staffs.joins(:member_code)
                                                     .select('external_staffs.*, member_codes.id AS member_code_id')
    # 退職処理の場合
    if params[:retire_external_staff_id].present?
      @retire_external_staff_id = params[:retire_external_staff_id]
    end
  end

  def update
    if @matter.update(matter_params)
      flash[:success] = "担当者を更新しました"
      # 退職処理の場合
      if params[:matter][:retire_external_staff_id].present?
        @external_staff = ExternalStaff.find(params[:matter][:retire_external_staff_id])
        redirect_to employees_external_staff_retirements_path(@external_staff)
      else
        redirect_to vendor_managers_matter_path(@matter)
      end
    end
  end

  def registor_started_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(started_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_start_date
  end

  def registor_finished_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(finished_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_start_date
  end

  def calendar
    if params[:start_date].present?
      @object_day = params[:start_date].to_date
    else
      @object_day = Date.current
    end
    @calendar_span = Span.new
    @calendar_span.simple_calendar(@object_day)
    construction_schedules_for_matter_calender(@matter, @calendar_span.first_day, @calendar_span.last_day)
    @calendar_type = "construction_schedule_for_matter"
  end

  private
    def matter_params
      params.require(:matter).permit( member_code_ids: [] )
    end

    def set_matter_detail_valiable
      @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
      @vendors = @matter.vendors
    end

    def set_matter
      @matter = Matter.find(params[:id])
    end

    def set_vendor
      @vendor = current_vendor_manager.vendor
    end
end
