class Employees::EstimateMatters::ConstructionsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_construction

  def edit
  end

  def update
    if @construction.update(construction_params)
      @response = "success"
      set_estimates_details(@estimate_matter)
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @construction.destroy
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_construction
      @construction = Construction.find(params[:id])
    end

    def construction_params
      params.require(:construction).permit(:name, :price, :amount)
    end
end
