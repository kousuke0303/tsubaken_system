class Employees::EstimateMatters::MaterialsController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_material

  def edit
  end

  def update
  end

  def destroy
    @material.destroy
    @estimates = @estimate_matter.estimates.with_categories
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
end
