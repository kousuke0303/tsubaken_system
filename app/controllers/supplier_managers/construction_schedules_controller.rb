class SupplierManagers::ConstructionSchedulesController < ApplicationController
  
  before_action :authenticate_supplier_manager!
  before_action :set_construction_schedule, except: :index
  
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
    @supplier = current_supplier_manager.supplier 
    @supplier_staff_codes_ids = @supplier.supplier_member_ids_for_matter_select(@construction_schedule.matter)
  end
  
  def update
    if @construction_schedule.update(update_params)
      @construction_schedules = @construction_schedule.matter.construction_schedules.includes(:materials, :supplier).order_reference_date
      @responce = "success"
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
    
end
