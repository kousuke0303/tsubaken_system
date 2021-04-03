class Employees::SchedulesController < Employees::EmployeesController
  before_action :all_member, only: [:new, :edit, :change_member]
  before_action :all_member_code
  before_action :set_schedule, except: [:new, :index, :create, :application, :commit_application]
  before_action :set_manager, if: :object_is_manager?, only: [:change_member]
  before_action :set_staff, if: :object_is_staff?, only: [:change_member]
  before_action :target_external_staff, if: :object_is_external_staff?, only: [:change_member]
  before_action :schedule_application, only: :application
  
  def index
    @object_day = Date.current
    set_basic_schedules(@object_day)
  end
  
  def new
    @schedule = Schedule.new
  end
  
  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.sender = login_user.member_code.id
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
  end
  
  def update
    attr_set_for_update
    if @schedule.update(schedule_params)
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def change_member
  end
  
  def update_member
    if @schedule.update(schedule_params)
      set_valiable
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def destroy
    attr_set_for_destroy
    @schedule.destroy
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
  end
  
  def apllication
  end
  
  def application_detail
    @applicated_schedule = @schedule
    @origin_schedule = @schedule.original
    diff
  end
  
  def commit_application
    @applicated_schedule = Schedule.find(params[:id])
    @origin_schedule = @applicated_schedule.original
    if @applicated_schedule.update(schedule_params.merge(schedule_id: nil))
      @origin_schedule.destroy
      flash[:success] = "#{@applicated_schedule.title}の変更申請を承認しました"
      redirect_to application_employees_schedules_url
    end
  end
  
  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
  
    def schedule_params
      params.require(:schedule).permit(:title, :scheduled_date,
                                       :scheduled_start_time,
                                       :scheduled_end_time,
                                       :place, :note,
                                       :member_code_id)
    end
    
    def diff
      difference = @applicated_schedule.attributes.to_a - @origin_schedule.attributes.to_a
      @diff = Hash[*difference.flatten]
      @diff.delete('id')
      @diff.delete('edit_reason')
      @diff.delete('schedule_id')
      @diff.delete('sales_status_id')
      @diff.delete('created_at')
      @diff.delete('updated_at')
    end
    
    def set_valiable
      if params[:schedule][:manager_id].present?
        @manager = Manager.find(params[:schedule][:manager_id])
        @schedules = Schedule.where(member_code_id: @manager.member_code.id).where('scheduled_date >= ?', Date.today)
      elsif params[:schedule][:staff_id].present? 
        @staff = Staff.find(params[:schedule][:staff_id])
        @schedules = Schedule.where(member_code_id: @staff.member_code.id).where('scheduled_date >= ?', Date.today)
      elsif params[:schedule][:external_staff_id].present? 
        @external_staff = ExternalStaff.find(params[:schedule][:external_staff_id])
        @schedules = Schedule.where(member_code_id: @external_staff.member_code.id).where('scheduled_date >= ?', Date.today)
      end
    end
    
    def attr_set_for_update
      @schedule.sender = login_user.member_code.id
      @schedule.before_title = @schedule.title
      if params[:schedule][:member_code_id].to_i != @schedule.member_code_id
        @schedule.before_member_code = @schedule.member_code_id
      end
      if params[:schedule][:scheduled_date] != @schedule.scheduled_date
        @schedule.before_scheduled_date = @schedule.scheduled_date
      end
      if params[:schedule][:scheduled_start_time] != @schedule.scheduled_start_time
        @schedule.before_scheduled_start_time = @schedule.scheduled_start_time
      end
      if params[:schedule][:scheduled_end_time] != @schedule.scheduled_end_time
        @schedule.before_scheduled_end_time = @schedule.scheduled_end_time
      end
    end
    
    def attr_set_for_destroy
      @schedule.sender = login_user.member_code.id
      @schedule.before_member_code = @schedule.member_code_id
      @schedule.before_title = @schedule.title
      @schedule.before_scheduled_date = @schedule.scheduled_date
      @schedule.before_scheduled_start_time = @schedule.scheduled_start_time
      @schedule.before_scheduled_end_time = @schedule.scheduled_end_time
    end
    
end
