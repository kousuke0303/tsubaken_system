class Employees::MattersController < Employees::EmployeesController
  before_action :set_matter, except: [:new, :create, :index]
  # アクセス制限
  before_action ->{can_access_only_of_member(@matter)}, except: :index
  
  before_action :set_reports_of_matter, only: :show
  before_action :set_employees, only: [:new, :edit, :change_member]
  before_action ->{set_menbers_code_for(@matter)}, only: :show
  before_action ->{can_access_only_of_member(@matter)}, except: :index
  before_action :all_staff_and_external_staff_code, only: [:edit, :change_member]
  
  # 見積案件から案件を作成ページ
  def new
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @matter = Matter.new
    set_estimates_with_plan_names_and_label_colors
  end

  # 見積案件から案件を作成
  def create
    estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @matter = estimate_matter.build_matter(estimate_matter.attributes.merge(estimate_id: params[:matter][:estimate_id].to_i,
                                                                            scheduled_started_on: params[:matter][:scheduled_started_on],
                                                                            scheduled_finished_on: params[:matter][:scheduled_finished_on]))
    @matter.save ? @responce = "success" : @responce = "failure"
  end

  def index
    @matters = Matter.all
    unless current_admin || current_manager
      @matters = Matter.joins(:member_codes).where(member_codes: { id: login_user.member_code.id })
    end
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
    set_classified_tasks(@matter)
    set_estimates_with_plan_names_and_label_colors
    set_invoice_valiable
    @message = true if params[:type] == "success"
    @images = @matter.images.select{ |image| image.image.attached? }
    @report_cover = @matter.report_cover    
    set_images_of_report_cover if @report_cover.present?
    gon.matter_id = @matter.id
    @construction_schedules = @matter.construction_schedules.includes(:materials, :supplier).order_start_date
  end

  def edit
    # @estimates = @matter.estimate_matter.estimates.with_plan_names_and_label_colors
    # @external_staff_codes_ids = @matter.member_codes.joins(:external_staff).ids
    case params[:edit_type]
    when "basic"
      @edit_type = "basic"
    when "staff"
      @edit_type = "staff"
      @staff_codes_ids = @matter.member_codes.joins(:staff).ids
    when "supplier"
      @edit_type = "supplier"
      @suppliers = Supplier.all
    when "supplier_staff"
      @edit_type = "supplier_staff"
      @supplier = Supplier.find(params[:supplier_id])
      @supplier_staff_codes_ids = @supplier.external_staffs.joins(:member_code)
                                                           .select('external_staffs.*, member_codes.id AS member_code_id')
    when "alert"
      @edit_type = "supplier_alert"
      difference_ids = params[:difference].map{|id| id.to_i }
      @alert_suppliers = Supplier.where(id: difference_ids)
    end
  end

  def update
    if @matter.update(matter_params)
      if params[:matter][:supplier_ids].present?
        delete_supplier_staff_for_delete_supplier
      end
      flash[:success] = "案件情報を更新しました"
      redirect_to employees_matter_url(@matter)
    end
  end

  def destroy
    @matter.destroy ? flash[:success] = "案件を削除しました" : flash[:alert] = "案件を削除できませんでした"
    redirect_to employees_matters_url
  end
  
  def change_estimate
    if @matter.change_invoice(params[:matter][:estimate_id])
      @responce = "success"
      @invoice = @matter.invoice
      set_invoice_details
    else
      @responce = "failure"
    end
  end
  
  def calendar
    if params[:start_date].present?
      @object_day = params[:start_date].to_date
    else
      @object_day = Date.current
    end
    @calendar_span = Span.new
    @calendar_span.simple_calendar(@object_day)
    construction_schedules_for_matter_calender(@matter, @calendar_span.first_day, @calendar_span.last_day)
    @calendar_type = "construction_schedule_for_matter"
  end

  private
    def matter_params
      params.require(:matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :address_street, :scheduled_started_on, 
                                     :scheduled_finished_on, :status, :estimate_id, :started_on, :finished_on, :maintenanced_on,
                                     { supplier_ids: [] })
    end
    
    def set_matter_detail_valiable
      @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
      @suppliers = @matter.suppliers
    end
    
    def set_invoice_valiable
      @invoice = @matter.invoice
      set_plan_name_of_invoice
      set_color_code_of_invoice     
      set_invoice_details
    end
    
    def delete_supplier_staff_for_delete_supplier
      suppliers_ids = @matter.suppliers.ids
      delete_supplier_staffs = @matter.member_codes.joins(:external_staff)
                                                   .where.not(external_staffs: {supplier_id: suppliers_ids})
      delete_matter_member_codes = @matter.matter_member_codes.where(member_code_id: delete_supplier_staffs)
      delete_matter_member_codes.each do |matter_member_code|
        matter_member_code.destroy
      end
    end
end
