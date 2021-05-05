class Employees::MattersController < Employees::EmployeesController
  before_action :authenticate_employee_except_external_staff!
  before_action :set_matter, except: [:new, :create, :index]
  before_action :set_reports_of_matter, only: :show
  before_action :set_employees, only: [:new, :edit, :change_member]
  before_action ->{set_menbers_code_for(@matter)}, only: :show
  before_action :set_suppliers, only: :edit
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
    @construction_schedules = @matter.construction_schedules.order_reference_date
  end

  def edit
    @estimates = @matter.estimate_matter.estimates.with_plan_names_and_label_colors
    @staff_codes_ids = @matter.member_codes.joins(:staff).ids
    @external_staff_codes_ids = @matter.member_codes.joins(:external_staff).ids
    case params[:edit_type]
    when "basic"
      @edit_type = "basic"
    when "person_in_charge"
      @edit_type = "person_in_charge"
    end
  end

  def update
    if params[:type] == "person_in_charge"
      params[:matter][:member_code_ids] = params[:matter][:staff_ids].push(params[:matter][:external_staff_ids])
      params[:matter][:member_code_ids].flatten!
    end
    if @matter.update(matter_params)
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
  
  def change_member
    if params[:staff_id].present?
      set_staff
    elsif params[:external_staff_id].present?
      target_external_staff
    end
    @staff_codes = @matter.member_codes.joins(:staff).select('member_codes.*')
    @external_staff_codes =  @matter.member_codes.joins(:external_staff).select('member_codes.*')
  end
  
  def update_member
    params[:matter][:member_code_ids] = params[:matter][:staff_ids].push(params[:matter][:external_staff_ids])
    params[:matter][:member_code_ids].flatten!
    @matter.update(matter_params)
    flash[:success] = "#{ @matter.title }の担当者を変更しました"
    if params[:matter][:staff_id].present?
      @staff = Staff.find(params[:matter][:staff_id])
      redirect_to retirement_process_employees_staff_url(@staff)
    elsif params[:matter][:external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:matter][:external_staff_id])
      redirect_to retirement_process_employees_external_staff_url(@external_staff)
    end
  end

  private
    def matter_params
      params.require(:matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :address_street, :scheduled_started_on, 
                                     :scheduled_finished_on, :status, :estimate_id, :started_on, :finished_on, :maintenanced_on,
                                     { member_code_ids: [] }, { supplier_ids: [] })
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
end
