class Employees::EstimateMattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_employees, only: [:new, :edit]

  def index
    @estimate_matters = EstimateMatter.includes(:client)
  end

  def new
    @estimate_matter = EstimateMatter.new
  end

  def create
    @estimate_matter = EstimateMatter.new(estimate_matter_params)
    if @estimate_matter.save
      flash[:success] = "見積案件を作成しました。"
      redirect_to employees_estimate_matters_url(@estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @tasks = @estimate_matter.tasks
    set_classified_tasks(@estimate_matter)
    @estimates = @estimate_matter.estimates
    @matter = @estimate_matter.matter
  end

  def edit
  end

  def update
    if @estimate_matter.update(estimate_matter_params)
      flash[:success] = "見積案件を更新しました。"
      redirect_to employees_estimate_matter_url(@estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @estimate_matter.destroy ? flash[:success] = "見積案件を削除しました。" : flash[:alert] = "見積案件を削除できませんでした。"
    redirect_to employees_estimate_matters_url
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:id])
    end

    def set_employees
      @clients = Client.all
      @staffs = Staff.all
      @external_staffs = ExternalStaff.all
    end

    def estimate_matter_params
      params.require(:estimate_matter).permit(:title, :content, :zip_code, :address, :client_id, :status, { staff_ids: [] }, { external_staff_ids: [] })
    end
end
