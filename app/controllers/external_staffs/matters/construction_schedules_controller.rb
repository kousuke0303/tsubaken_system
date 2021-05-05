class ExternalStaffs::Matters::ConstructionSchedulesController < Employees::Matters::ConstructionSchedulesController
  before_action :authenticate_external_staff!
  
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
    super
  end
  
  
end
