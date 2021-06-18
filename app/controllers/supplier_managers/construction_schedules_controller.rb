class SupplierManagers::ConstructionSchedulesController < ApplicationController
  
  before_action :authenticate_supplier_manager!
  before_action :set_construction_schedule, except: :index
  
  def index
    @type = "construction_schedule"
    @object_day = Date.current
    @ganttchart_span = Span.new
    @ganttchart_span.construction_schedule_calendar(@object_day)
    month_construction_schedules(@ganttchart_span.first_day, @ganttchart_span.last_day)
  end
  
  def show
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
    
    def month_construction_schedules(first_day, last_day)
      construction_schedules = current_supplier_manager.supplier.construction_schedules
      @target_construction_schedules = construction_schedules.where(started_on: first_day..last_day)
                               .or(construction_schedules.where(finished_on: first_day..last_day))
                               .or(construction_schedules.where(scheduled_started_on: first_day..last_day))
                               .or(construction_schedules.where(scheduled_finished_on: first_day..last_day))
    end
end
