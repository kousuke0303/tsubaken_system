class Employees::Matters::ConstructionSchedulesController < Employees::EmployeesController
  before_action :set_matter_by_matter_id
  
  def new
    @construction_schedule = @matter.construction_schedules.new
    @suppliers = @matter.suppliers
  end
  
  def create
    @construction_schedule = @matter.construction_schedules.new(construction_schedule_params)
    if @construction_schedule.save
      @responce = "success"
      @construction_schedules = @matter.construction_schedules
    else
      @responce = "failure"
    end
  end
  
  def edit
    @construction_schedule = ConstructionSchedule.find(params[:id])
    @suppliers = @matter.suppliers
  end
  
  def update
    @construction_schedule = ConstructionSchedule.find(params[:id])
    if @construction_schedule.update(construction_schedule_params)
      @responce = "success"
      @construction_schedules = @matter.construction_schedules
    else
      @responce = "failure"
    end
  end
  
  def destroy
    @construction_schedule = ConstructionSchedule.find(params[:id])
    if @construction_schedule.destroy
      @responce = "success"
      @construction_schedules = @matter.construction_schedules
    else
      @responce = "failure"
    end
  end
  
  private
    def construction_schedule_params
      params.require(:construction_schedule).permit(:title, :content, :scheduled_started_on, :scheduled_finished_on, :supplier_id)
    end
  
  
end
