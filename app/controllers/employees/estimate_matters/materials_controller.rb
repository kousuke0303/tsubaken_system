class Employees::EstimateMatters::MaterialsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_material

  def edit
  end

  def update
    if @material.update(material_params)
      @response = "success"
      @estimates = @estimate_matter.estimates.with_details
      @materials = Material.of_estimate_matter(@estimate_matter.id)
      @constructions = Construction.of_estimate_matter(@estimate_matter.id)
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @material.destroy
    @estimates = @estimate_matter.estimates.with_details
    @materials = Material.of_estimate_matter(@estimate_matter.id)
    @constructions = Construction.of_estimate_matter(@estimate_matter.id)
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
