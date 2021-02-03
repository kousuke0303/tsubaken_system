class Employees::SchedulesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :all_member, only: [:new, :edit]
  before_action :set_schedule, only: [:edit, :update, :destroy]
  
  def index
    @object_day = Date.current
    set_basic_schedules(@object_day)
  end
  
  def new
    @schedule = Schedule.new
  end
  
  def create
    # 担当者パラメータ整形
    formatted_member_params(params[:schedule][:member], schedule_params)
    @schedule = Schedule.new(@final_params)
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
    # 担当者クリア
    
    ActiveRecord::Base.transaction do
      @schedule.update!(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
      @schedule.update!(@final_params)
    end  
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
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
    
    def member_in_charge(schedule_params)
      params_member = params[:schedule][:member].split("#")
      member_authority = params_member[0]
      params_member_id = params_member[1].to_i
      case member_authority
      when "admin"
        admin_id = Admin.find(params_member_id).id
        @schedule_params = schedule_params.merge(admin_id: admin_id)
      when "manager"
        manager_id = Manager.find(params_member_id).id
        @schedule_params = schedule_params.merge(manager_id: manager_id)
      when "staff"
        staff_id = Staff.find(params_member_id).id
        @schedule_params = schedule_params.merge(staff_id: staff_id)
      when "external_staff"
        external_staff_id = ExternalStaff.find(params_member_id).id
        @schedule_params = schedule_params.merge(external_staff_id: external_staff_id)
      end
    end

end
