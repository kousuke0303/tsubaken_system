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
    @adopted_estimate_details = @adopted_estimate.adopted_estimate_details
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

    # パラメーター整形
    def refactor_params_material_and_construction_ids
      if params[:adopted_estimate_detail][:material_ids].present?
        params_materials = params[:adopted_estimate_detail][:material_ids].split(",").map(&:to_i)
        @after_material_array = []
        params_materials.each do |params_material|          
          @after_material_array << params_material unless params_material == 0
        end
      end
      if params[:adopted_estimate_detail][:construction_ids].present?
        params_constructions = params[:adopted_estimate_detail][:construction_ids].split(",").map(&:to_i)
        @after_construction_array = []
        params_constructions.each do |params_construction|          
          @after_construction_array << params_construction unless params_construction == 0          
        end
      end
    end

    def comparison
      if @after_material_array.present?
        before_material_array = @target_details_include_material.pluck(:material_id)
        # カテゴリが増えている場合
        (@after_material_array - before_material_array) == [nil] || @after_material_array == before_material_array ?
        @add_material_array = "nil" : @add_material_array = @after_material_array - before_material_array                  
        # カテゴリが減っている場合
        (before_material_array - @after_material_array) == [nil] || before_material_array == @after_material_array ?
        @delete_material_array = "nil" : @delete_material_array = before_material_array - @after_material_array
      end

      if @after_construction_array.present?
        before_construction_array = @target_details_include_construction.pluck(:construction_id)
        # カテゴリが増えている場合
        if (@after_construction_array - before_construction_array) == [nil]
          @add_construction_array = "nil"
        elsif @after_construction_array == before_construction_array
          @add_construction_array = "nil"
        else
          @add_construction_array = @after_construction_array - before_construction_array
        end
        
        # カテゴリが減っている場合
        if (before_construction_array - @after_construction_array) == [nil]
          @delete_construction_array = "nil"
        elsif before_construction_array == @after_construction_array
          @delete_construction_array = "nil"
        else
          @delete_construction_array = before_construction_array - @after_construction_array
        end
      end
    end

        
    # 素材登録
    def register_materials(material_id_array)
      material_id_array.each.with_index(1) do |params_material_id, index|
        default_material = Material.find(params_material_id)
        EstimateDetail.create(
            estimate_id: @estimate_detail.estimate.id,
            category_id: @estimate_detail.category_id,
            category_name: @estimate_detail.category_name,
            material_id: default_material.id,
            material_name: default_material.name,
            unit: default_material.unit, 
            price: default_material.price, 
            service_life: default_material.service_life, 
            sort_number: @estimate_detail.sort_number + index + 30
            )
      end
    end
    
    # 素材削除
    def decrease_materials(material_id_array)
      material_id_array.each do |material_id|
        objects = @estimate.estimate_details.where(material_id: material_id, category_id: @target_category)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    # 工事登録
    def register_constructions(construction_id_array)
      construction_id_array.each.with_index(1) do |params_construction_id, index|
        default_construction = Construction.find(params_construction_id)
        EstimateDetail.create(
            adopted_estimate_id: @estimate_detail.estimate.id,
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
    
    # 工事削除
    def decrease_constructions(construction_id_array)
      construction_id_array.each do |construction_id|
        objects = @adopted_estimate.adopted_estimate_details.where(construction_id: construction_id, category_id: @target_category)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    # 順番変更
    def change_order
      if @after_material_array.present?
        details_for_material = @adopted_estimate.adopted_estimate_details.where(category_id: @target_category).where.not(material_id: nil).sort_by{|detail| @after_material_array.index(detail.material_id)}
        # 素材内の順番変更
        basic_sort_number = details_for_material.first.sort_number
        details_for_material.each.with_index(1) do |detail, i|
          detail.update(sort_number: basic_sort_number + i)
        end
      end
      if @after_construction_array.present?
        details_for_construction = @adopted_stimate.adopted_estimate_details.where(category_id: @target_category).where.not(construction_id: nil).sort_by{|detail| @after_construction_array.index(detail.construction_id)}
        # 工事内の順番変更
        basic_sort_number = details_for_construction.first.sort_number
        details_for_construction.each.with_index(1) do |detail, i|
          detail.update(sort_number: detail.sort_number + i)
        end
      end
      # 見積全体の順番リセット
      @adopted_estimate.adopted_estimate_details.order(:sort_number).each.with_index(1) do |detail, i|
        detail.update(sort_number: i * 100)
      end
    end
end
