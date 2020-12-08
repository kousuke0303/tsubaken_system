class Employees::EstimateMatters::CategoriesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_category

  def edit
    @materials = @category.parent.materials
    @constructions = @category.parent.constructions
  end

  def update
    params[:category]["material_ids"].each do |material_id|
      default_material = Material.find(material_id)
      @category.materials.create(name: default_material.name, unit: default_material.unit,
                                 price: default_material.price, service_life: default_material.service_life)
    end
    @estimates = @estimate_matter.estimates.with_categories
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category.destroy
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @estimates = @estimate_matter.estimates.with_categories
    respond_to do |format|
      format.js
    end
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def set_category
      @category = Category.find(params[:id])
    end
end