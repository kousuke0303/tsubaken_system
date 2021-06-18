class SupplierManagers::MattersController < ApplicationController
  before_action :authenticate_supplier_manager!
  before_action :set_matter, except: :index
  before_action :set_supplier
  
  def index
    @matters = current_supplier_manager.matters
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
    @construction_schedules = @matter.construction_schedules.includes(:materials, :supplier).order_start_date
  end
  
  def edit
    @supplier = Supplier.find(params[:supplier_id])
    @supplier_staff_codes_ids = @supplier.external_staffs.joins(:member_code)
                                                         .select('external_staffs.*, member_codes.id AS member_code_id')
  end
  
  def update
    if @matter.update(matter_params)
      flash[:success] = "案件情報を更新しました"
      redirect_to supplier_managers_matter_path(@matter)
    end
  end
  
  def registor_started_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(started_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_start_date
  end
  
  def registor_finished_on
    @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    @construction_schedule.update(finished_on: Date.current)
    @construction_schedules = @matter.construction_schedules.order_start_date
  end
  
  private
    def matter_params
      params.require(:matter).permit( member_code_ids: [] )
    end
  
    def set_matter_detail_valiable
      @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
      @suppliers = @matter.suppliers
    end
    
    def set_matter
      @matter = Matter.find(params[:id])
    end
    
    def set_supplier
      @supplier = current_supplier_manager.supplier
    end

end

