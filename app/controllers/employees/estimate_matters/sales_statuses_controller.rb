class Employees::EstimateMatters::SalesStatusesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:edit, :update, :destroy]
  before_action ->{ set_person_in_charge(@estimate_matter) }, only: [:new, :edit]

  def new
    @sales_status = @estimate_matter.sales_statuses.new
  end

  def create
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)
    if @sales_status.save
      @response = "success"
      @sales_statuses = @estimate_matter.sales_statuses
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end
  
  def edit
  end

  def update
    if @sales_status.update(sales_status_params)
      @response = "success"
      @sales_statuses = @estimate_matter.sales_statuses
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @sales_status.destroy
    @sales_statuses = @estimate_matter.sales_statuses
    respond_to do |format|
      format.js
    end
  end

  private
    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:status, :conducted_on, :note, :staff_id, :external_staff_id)
    end
end
