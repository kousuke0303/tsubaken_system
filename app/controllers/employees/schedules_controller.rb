class Employees::SchedulesController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :all_member_code, only: [:new, :edit]
  before_action :set_schedule, except: [:new, :index, :create, :application, :commit_application, :show_for_top_page]
  before_action :set_manager, if: :object_is_manager?, only: [:change_member]
  before_action :set_staff, if: :object_is_staff?, only: [:change_member]
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
      @reciever_notification_count = @schedule.member_code.recieve_notifications.count
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
  
  def show_for_top_page
    @schedule = Schedule.find(params[:schedule_id])
    if @schedule.sales_status_id
      @estimate_matter = EstimateMatter.find(@schedule.sales_status.estimate_matter_id)
    end
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
      @reciever_notification_count = @schedule.member_code.recieve_notifications.count
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def destroy
    @schedule.sender = login_user.member_code.id
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
    
end
