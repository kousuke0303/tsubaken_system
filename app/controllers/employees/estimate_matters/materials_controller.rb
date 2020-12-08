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
    respond_to do |format|
      format.js
    end
    @estimates = @estimate_matter.estimates.with_categories
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_material
      @material = Materail.find(params[:id])
    end
end
