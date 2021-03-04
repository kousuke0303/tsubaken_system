class Employees::MattersController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_employees, only: :new
  before_action :set_suppliers, only: :edit
  before_action :can_access_only_matter_of_being_in_charge

  # 見積案件から案件を作成ページ
  def new
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @matter = Matter.new
    set_estimates_with_label_colors
  end

  # 見積案件から案件を作成
  def create
    estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    estimate = Estimate.find(params[:matter]["estimate_id"])
    ActiveRecord::Base.transaction do
      @matter = Matter.create!(title: estimate_matter.title, content: estimate_matter.content, estimate_matter_id: estimate_matter.id)
      @default_task_scaffolding_request = @matter.tasks.create!(title: "足場架設依頼", status: 1, sort_order: 1)
      @default_task_order_request = @matter.tasks.create!(title: "発注依頼", status: 1, sort_order: 2)
      estimate.update!(matter_id: @matter.id)
      if current_admin || current_manager
        @matter.update!(matter_staff_external_staff_client_params)
      elsif current_staff
        MatterStaff.create!(matter_id: @matter.id, staff_id: current_staff.id)
      elsif current_external_staff
        MatterExternalStaff.create!(matter_id: @matter.id, external_staff_id: current_external_staff.id)
      end
      flash[:notice] = "案件を作成しました。"
    rescue
      flash[:notice] = "案件の作成に失敗しました。"      
    end
    redirect_to employees_estimate_matter_path(estimate_matter) 
  end

  def index
    if current_admin || current_manager
      @matters = Matter.all
    elsif current_staff
      @staff_matters = current_staff.matters
    elsif current_external_staff
      @external_staff_matters = current_external_staff.matters
    end
    # 進行状況での絞り込みがあった場合
    if params[:status] && params[:status] == "not_started"
      @matters = @matters.not_started
    elsif params[:status] && params[:status] == "progress"
      @matters = @matters.progress
    elsif params[:status] && params[:status] == "completed"
      @matters = @matters.completed
    end
  end

  def show
    @staffs = @matter.staffs
    @external_staffs = @matter.external_staffs
    @suppliers = @matter.suppliers
    @tasks = @matter.tasks
    set_classified_tasks(@matter)    
    @estimate_matter = @matter.estimate_matter
    @client = @estimate_matter.client
    @address = "#{ @estimate_matter.prefecture_code }#{ @estimate_matter.address_city }#{ @estimate_matter.address_street }"
  end

  def edit
    @staffs = Staff.all
    @external_staffs = ExternalStaff.all
    @estimates = @matter.estimate_matter.estimates
  end

  def update
    if @matter.update(matter_params)
      flash[:success] = "案件情報を更新しました"
      redirect_to employees_matter_url(@matter)
    end
  end

  def destroy
    @matter.destroy ? flash[:success] = "案件を削除しました" : flash[:alert] = "案件を削除できませんでした"
    redirect_to employees_matters_url
  end

  private
    def set_matter
      @matter = Matter.find(params[:id])
    end

    def matter_params
      params.require(:matter).permit(:title, :scheduled_started_on, :scheduled_finished_on, :status, :estimate_id,
                                     :started_on, :finished_on, :maintenanced_on, { staff_ids: [] }, { external_staff_ids: [] }, { supplier_ids: [] })
    end
    
    def matter_staff_external_staff_client_params
      params.permit({ staff_ids: [] }, { external_staff_ids: [] }, { supplier_ids: [] })
    end
end
