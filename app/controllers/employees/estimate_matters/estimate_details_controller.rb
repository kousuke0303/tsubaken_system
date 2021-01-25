class Employees::EstimateMatters::EstimateDetailsController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate_detail

  def edit
    @materials = Material.where(category_id: @estimate_detail.category_id)
    @constructions = Construction.where(category_id: @estimate_detail.category_id)
    current_estimate = @estimate_detail.estimate
    @estimate_details = current_estimate.estimate_details.where(category_id: @estimate_detail.category_id)
    respond_to do |format|
      format.js
    end
  end

  def update
    unless @estimate_detail.material_id.present? && @estimate_detail.construction_id.present?
      if params[:estimate_detail][:material_ids].present?
        params_materials = params[:estimate_detail][:material_ids].split(",").map(&:to_i)
        params_materials.each.with_index(1) do |params_material, index|
          default_material = Material.find(params_material)
          EstimateDetail.create(
            estimate_id: @estimate_detail.estimate.id,
            category_id: @estimate_detail.category_id,
            category_name: @estimate_detail.category_name,
            material_id: default_material.id,
            material_name: default_material.name,
            unit: default_material.unit, 
            price: default_material.price, 
            service_life: default_material.service_life, 
            sort_number: @estimate_detail.sort_number + index
            )
        end
      end
      if params[:estimate_detail][:construction_ids].present?
        params_constructions = params[:estimate_detail][:construction_ids].split(",").map(&:to_i)
        params_constructions.each.with_index(1) do |params_construction, index|
          default_construction = Construction.find(params_construction)
          EstimateDetail.create(
            estimate_id: @estimate_detail.estimate.id,
            category_id: @estimate_detail.category_id,
            category_name: @estimate_detail.category_name,
            construction_id: default_construction.id,
            construction_name: default_construction.name,
            unit: default_construction.unit, 
            price: default_construction.price, 
            sort_number: @estimate_detail.sort_number + index
            )
        end
      end
      @estimate_detail.destroy
    end
    @estimates = @estimate_matter.estimates
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
    
    def prerequisite_processing_for_update
      # カテゴリの差分
      before_category_arrey = @estimate.estimate_details.pluck(:category_id)
      params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
      @after_category_arrey = []
      # 空欄を除く
      params_categories.each do |params_categopry|
        unless params_categopry == 0
          @after_category_arrey << params_categopry
        end
      end
      
      # カテゴリが増えている場合
      if (params_categories - before_category_arrey).present?
        @add_categories = @after_category_arrey - before_category_arrey
      end
      # カテゴリが減っている場合
      if (before_category_arrey - params_categories).present?
        @delete_categories = before_category_arrey - @after_category_arrey
      end
    end
    
    def change_category_order
      sort_details = @estimate.estimate_details.sort_by{|detail| @after_category_arrey.index(detail.category_id)}
      sort_categories.each.with_index(1) do |sort_category, i|
        sort_category.update(sort_number: i)
      end
    end
end
