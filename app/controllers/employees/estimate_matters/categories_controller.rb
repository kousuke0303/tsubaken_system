class Employees::EstimateMatters::CategoriesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate_detail

  def edit
    @materials = Material.where(category_id: @estimate_detail.category_id)
    @constructions = Construction.where(category_id: @estimate_detail.category_id)
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
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @category.destroy
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_estimate_detail
      @estimate_detail = EstimateDetail.find(params[:id])
    end
end
