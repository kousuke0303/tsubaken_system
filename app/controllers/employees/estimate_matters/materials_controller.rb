class Employees::EstimateMatters::MaterialsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_material

  def edit
  end

  def update
    if @material.update(material_params)
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
    @material.destroy
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_material
      @material = Material.find(params[:id])
    end

    def material_params
      params.require(:material).permit(:name, :service_life, :price, :amount)
    end
end
