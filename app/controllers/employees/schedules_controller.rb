class Employees::SchedulesController < Employees::EmployeesController
  before_action :all_member, only: [:new, :edit, :change_member]
  before_action :set_schedule, only: [:edit, :update, :destroy, :change_member, :update_member]
  before_action :set_staff, only: [:change_member, :update_member]
  
  def index
    @object_day = Date.current
    set_basic_schedules(@object_day)
  end
  
  def new
    @schedule = Schedule.new
  end
  
  def create
    if current_staff
      @schedule = Schedule.new(schedule_params.merge(staff_id: current_staff.id))
    elsif current_external_staff
      @schedule = Schedule.new(schedule_params.merge(current_staff_id: current_external_staff.id))
    else
      # 担当者パラメータ整形
      formatted_member_params(params[:schedule][:member], schedule_params)
      @schedule = Schedule.new(@final_params)
    end
    
    if @schedule.save
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def show
    @object_day = Schedule.find(params[:id]).scheduled_date
    set_basic_schedules(@object_day)
  end
  
  def edit
    if @schedule.sales_status_id.present?
      @type = "disable_update"
      @estimate_matter = SalesStatus.find(@schedule.sales_status_id).estimate_matter
    end
    if @schedule.admin_id.present?
      @member_value = "admin##{@schedule.admin_id}"
    elsif @schedule.manager_id.present?
      @member_value = "manager##{@schedule.manager_id}"
    elsif @schedule.staff_id.present?
      @member_value = "staff##{@schedule.staff_id}"
    elsif @schedule.external_staff_id.present?
      @member_value = "external_staff##{@schedule.external_staff_id}"
    end
  end
  
  def update
    # 担当者パラメーター整形
    formatted_member_params(params[:schedule][:member], schedule_params)
    @schedule.transaction do
      @schedule.update(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
      @schedule.update!(@final_params)
    end
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
    @result = "success"
  rescue
    @result = "failure" 
  end
  
  def change_member
  end
  
  def update_member
    formatted_member_params(params[:schedule][:member], schedule_params)
    @schedule.transaction do
      @schedule.update(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
      @schedule.update!(@final_params)
    end
    @object_day = @schedule.scheduled_date
    @schedules = @staff.schedules.where('scheduled_date >= ?', Date.today)
    @result = "success"
  rescue
    @result = "failure" 
  end
  
  def destroy
    @schedule.destroy
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
  end
  
  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
  
    def schedule_params
      params.require(:schedule).permit(:title, 
                                       :scheduled_date,
                                       :scheduled_start_time,
                                       :scheduled_end_time,
                                       :place,
                                       :note)
    end
    
end
