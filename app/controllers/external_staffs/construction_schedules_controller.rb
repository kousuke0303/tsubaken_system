class ExternalStaffs::ConstructionSchedulesController < ApplicationController
  
  before_action :authenticate_external_staff!
  before_action :set_construction_schedule, except: :index
  before_action :own_construction_schedule!, except: :index
  
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
  
  def picture
    @construction_schedule_pictures = @construction_schedule.images
  end
  
  private
    def set_construction_schedule
      @construction_schedule = ConstructionSchedule.find(params[:id])
    end
    
    def own_construction_schedule!
      unless @construction_schedule.member_codes.where(login_user.member_code.id)
        sign_out(login_user)
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_url
      end
    end

end
