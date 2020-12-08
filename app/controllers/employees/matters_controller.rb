class Employees::MattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_matter, only: [:show, :edit, :update, :destroy]

  # 見積案件から案件を作成
  def create
    estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    sort_order = Task.are_default.length
    @matter = Matter.new(title: estimate_matter.title, content: estimate_matter.content, estimate_matter_id: estimate_matter.id)
    @default_task_request = Task.new(default_task_request_1: "足場架設依頼", default_task_request_2: "発注依頼", status: 0, sort_order: sort_order)
    if @matter.save && @default_task_request.save  
      @default_task_request.update(default_task_request_id: @default_task_request.id) 
      flash[:alert] = "案件を作成しました。"
    else
      flash[:alert] = "案件の作成に失敗しました。"
    end
    redirect_to employees_estimate_matter_path(estimate_matter)
  end

  def index
    @matters = Matter.all
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
  end

  def edit
    @staffs = Staff.all
    @external_staffs = ExternalStaff.all
    @suppliers = Supplier.all
  end

  def update
    if @matter.update(matter_params)
      flash[:success] = "案件情報を更新しました"
      redirect_to employees_matter_url(@matter)
    else
      render :edit
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
      params.require(:matter).permit(:title, :scheduled_started_on, :scheduled_finished_on, :status,
                                     :started_on, :finished_on, :maintenanced_on, { staff_ids: [] }, { external_staff_ids: [] }, { supplier_ids: [] })
    end
end
