class Employees::EstimateMatters::EstimatesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter

  def new
    @estimate = @estimate_matter.estimates.new
  end

  def create
    @estimate = @estimate_matter.estimates.new(estimate_params)
    if @estimate.save
      @response = "success"
      @estimates = @estimate_matter.estimates
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def show
  end

  def edit
  end

  def update
    if @estimate.update(estimate_params)
      flash[:success] = "見積を作成しました。"
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @estimate.destroy ? flash[:success] = "見積を削除しました。" : flash[:alert] = "見積を削除できませんでした。"
  end

  private
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def estimate_params
      params.require(:estimate).permit(:title)
    end
end
