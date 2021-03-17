class Employees::Matters::AdoptedEstimateDetailsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id
  before_action :set_adopted_estimate_detail
  before_action :set_adopted_estimate_details, only: :update
  before_action :set_adopted_estimate_of_adopted_estimate_detail, only: [:edit, :update, :destroy]
  
  def edit
    @materials = Material.includes(:category_materials).where(plan_name_id: @adopted_estimate, category_materials: { category_id: @adopted_estimate_detail.category_id })
    @constructions = Construction.where(category_id: @adopted_estimate_detail.category_id)
    target_details = @adopted_estimate.adopted_estimate_details.where(category_id: @adopted_estimate_detail.category_id)
    @target_details_include_construction = target_details.where.not(construction_id: nil).order(:sort_number)
    @target_details_include_material = target_details.where.not(material_id: nil).order(:sort_number)
  end

  def update
    @target_category = @adopted_estimate_detail.category_id
    @target_details = @adopted_estimate_details.where(category_id: @target_category)
    @target_details_include_construction = @target_details.where.not(construction_id: nil).order(:sort_number)
    @target_details_include_material = @target_details.where.not(material_id: nil).order(:sort_number)
    refactor_params_material_and_construction_ids # ①パラメーター整形
    comparison # 差分比較  
    if @after_construction_array.present?      
      register_constructions(@add_construction_array) if @add_construction_array != "nil" # ①増加分      
      decrease_constructions(@delete_construction_array) if @delete_construction_array != "nil" # ②減少分
    end
    if @after_material_array.present?      
      register_materials(@add_material_array) if @add_material_array != "nil" # ①増加分      
      decrease_materials(@delete_material_array) if @delete_material_array != "nil" # ②減少分
    end
    
    #素材・工事が空のものを削除
    if @add_material_array != "nil" || @add_construction_array != "nil"
      @target_details.where(material_id: nil).where(construction_id: nil).destroy_all
    end
    
    # 順番変更
    change_order
    @adopted_estimate.calc_total_price
    set_plan_name_of_adopted_estimate
    set_color_code_of_adopted_estimate
    set_adopted_estimate_details
    @response = "success"
  end

  def destroy
    if params[:type] == "delete_category"
      @adopted_estimate.adopted_estimate_details.where(category_id: @adopted_estimate_detail.category_id).destroy_all
      @type = "delete_category"
    elsif params[:type] == "delete_object"
      @adopted_estimate_detail.destroy
      @type = "delete_object"
    end
    @adopted_estimate.calc_total_price
    set_plan_name_of_adopted_estimate
    set_color_code_of_adopted_estimate
    set_adopted_estimate_details
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
