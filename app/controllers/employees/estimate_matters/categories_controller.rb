class Employees::EstimateMatters::CategoriesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_category

  def edit
    @materials = @category.parent.materials
    @constructions = @category.parent.constructions
  end

  def update
    if params[:category]["material_ids"].present?
      params[:category]["material_ids"].each do |material_id|
        default_material = Material.find(material_id)
        @category.materials.create(name: default_material.name, unit: default_material.unit, price: default_material.price,
                                  service_life: default_material.service_life, parent_id: default_material.id)
      end
    end
    if params[:category]["construction_ids"].present?
      params[:category]["construction_ids"].each do |construction_id|
        default_construction = Construction.find(construction_id)
        @category.constructions.create(name: default_construction.name, unit: default_construction.unit, price: default_construction.price,
                                       parent_id: default_construction.id)
      end
    end
    @estimates = @estimate_matter.estimates.with_categories
    @materials = Material.of_estimate_matter(@estimate_matter.id)
    @constructions = Construction.of_estimate_matter(@estimate_matter.id)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category.destroy
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @estimates = @estimate_matter.estimates.with_categories
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

    def set_category
      @category = Category.find(params[:id])
    end
end
