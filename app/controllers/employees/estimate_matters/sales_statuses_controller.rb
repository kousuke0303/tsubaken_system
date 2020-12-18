class Employees::EstimateMatters::SalesStatusesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:edit, :update, :destroy]

  def new
    @sales_status = @estimate_matter.sales_statuses.new
  end

  def create
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)
    if @sales_status.save
      @response = "success"
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
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:name, :conducted_on, :note, :staff_id, :external_staff_id)
    end
end
