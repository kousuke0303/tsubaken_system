class Employees::Matters::AdoptedEstimateDetailsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id
  before_action :set_adopted_estimate_detail
  before_action :set_adopted_estimate_of_adopted_estimate_detail, only: [:edit, :update, :destroy]
  
  def edit
    @materials = Material.includes(:category_materials).where(plan_name_id: @adopted_estimate, category_materials: { category_id: @adopted_estimate_detail.category_id })
    @constructions = Construction.where(category_id: @adopted_estimate_detail.category_id)
    target_details = @adopted_estimate.adopted_estimate_details.where(category_id: @adopted_estimate_detail.category_id)
    @target_details_include_construction = target_details.where.not(construction_id: nil).order(:sort_number)
    @target_details_include_material = target_details.where.not(material_id: nil).order(:sort_number)
  end

  def update
    @estimate_details = @estimate.estimate_details
    @target_category = @estimate_detail.category_id
    @target_details = @estimate.estimate_details.where(category_id: @target_category)
    @target_details_include_construction = @target_details.where.not(construction_id: nil).order(:sort_number)
    @target_details_include_material = @target_details.where.not(material_id: nil).order(:sort_number)
    
    # ①パラメーター整形
    refactor_params_material_and_construction_ids
    
    # 差分比較
    comparison
    
    if @after_construction_arrey.present?
      # ①増加分
      register_constructions(@add_construction_arrey) if @add_construction_arrey != "nil"
      # ②減少分
      decrease_constructions(@delete_construction_arrey) if @delete_construction_arrey != "nil"
    end
    
    if @after_material_arrey.present?
      # ①増加分
      register_materials(@add_material_arrey) if @add_material_arrey != "nil"
      # ②減少分
      decrease_materials(@delete_material_arrey) if @delete_material_arrey != "nil"
    end
    
    #素材・工事が空のものを削除
    if @add_material_arrey != "nil" || @add_construction_arrey != "nil"
      @target_details.where(material_id: nil).where(construction_id: nil).destroy_all
    end
    
    # 順番変更
    change_order
    @estimate.calc_total_price
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
    @response = "success"
  end

  def destroy
    if params[:type] == "delete_category"
      @adopted_estimate.estimate_details.where(category_id: @estimate_detail.category_id).destroy_all
      @type = "delete_category"
    elsif params[:type] == "delete_object"
      @estimate_detail.destroy
      @type = "delete_object"
    end
    @estimate.calc_total_price
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
  end
  
  def detail_object_edit
  end
  
  def detail_object_update
    if @estimate_detail.valid?(:object_update) && @estimate_detail.update(object_params)
      @estimates = @estimate_matter.estimates
      @response = "success"
    else
      @response = "failure"
    end
    @estimate.calc_total_price
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
  end

  private
    def set_adopted_estimate_detail
      @adopted_estimate_detail = AdoptedEstimateDetail.find(params[:id])
    end

    def set_adopted_estimate_of_adopted_estimate_detail
      @adopted_estimate = @adopted_estimate_detail.adopted_estimate
    end
    
    def object_params
      params.require(:adopted_estimate_detail).permit(:name, :service_life, :price, :amount, :note)
    end
end
