class ExternalStaffs::Matters::ConstructionSchedulesController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_construction_schedule
  
  def update
    if @construction_schedule.started_on.nil?
      @construction_schedule.update(started_on: Date.current)
    else
      @construction_schedule.update(finished_on: Date.current)
    end
    @matter = Matter.find(params[:matter_id])
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end
  
  def picture
    @construction_schedule_pictures = @construction_schedule.images
  end
  
  private
    def set_construction_schedule
      @construction_schedule = ConstructionSchedule.find(params[:id])
    end
  
  
end
