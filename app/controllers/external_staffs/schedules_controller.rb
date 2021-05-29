class ExternalStaffs::SchedulesController < ApplicationController
  before_action :authenticate_external_staff!
  before_action :set_schedule, except: [:index, :new, :create]
  
  def index
    @object_day = Date.current
    set_basic_schedules(@object_day)
  end
  
  def new
    @schedule = Schedule.new
  end
  
  def create
    @schedule = current_external_staff.schedules.new(schedule_params)
    if @schedule.save
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def show
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
  end
  
  def show_for_top_page
    @schedule = Schedule.find(params[:schedule_id])
    if @schedule.sales_status_id
      @estimate_matter = EstimateMatter.find(@schedule.sales_status.estimate_matter_id)
    end 
  end
  
  def edit
    if @schedule.sales_status_id.present?
      @type = "disable"
    else
      @type = "able"
    end
  end
  
  def update
    if @schedule.update(schedule_params)
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def applicate
    @applicate_schedule = @schedule.applications.new(schedule_params.merge(external_staff_id: current_external_staff.id,
                                                     sales_status_id: @schedule.sales_status_id))
    if @applicate_schedule.save
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def destroy
    if @schedule.sales_status_id.present?
      @result = "failure"
    else
      @schedule.destroy
      flash[:success] = "#{@schedule.title}を削除しました"
      redirect_to external_staffs_schedules_url
    end
  end
  
  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
  
    def set_basic_schedules(day)
      @schedules = current_external_staff.schedules.origins
      @schedules_for_target_day = @schedules.where(scheduled_date: day)
                                            .sort_by{|schedule| schedule.scheduled_start_time.to_s(:time)}
    end
    
    def schedule_params
      params.require(:schedule).permit(:title, :scheduled_date,
                                       :scheduled_start_time,
                                       :scheduled_end_time,
                                       :place, :note,
                                       :edit_reason)
    end

end
