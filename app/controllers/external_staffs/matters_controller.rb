class ExternalStaffs::MattersController < Employees::EmployeesController
  before_action :authenticate_external_staff!
  before_action :set_matter, except: :index
  before_action ->{set_menbers_code_for(@matter)}, only: :show
  
  def index
    @matters = Matter.joins(:member_codes).where(member_codes: { id: login_user.member_code.id })
    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.where(status: "not_started")
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.where(status: "progress")
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.where(status: "completed")
    end
  end
  
  def show
    set_matter_detail_valiable
    @client = @matter.client
    @estimate_matter = @matter.estimate_matter
    @message = true if params[:type] == "success"
    @images = @matter.images.select{ |image| image.image.attached? }
    gon.matter_id = @matter.id
    @construction_schedules = @matter.construction_schedules
    @construction_schedules = @construction_schedules.order_reference_date
  end
  
  def registor_started_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(started_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end
  
  def registor_finished_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(finished_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end
  
  private
    def set_matter_detail_valiable
      @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
      @suppliers = @matter.suppliers
    end

end
