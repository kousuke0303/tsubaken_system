class Employees::EstimateMatters::EstimateDetailsController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate_detail
  before_action :set_default_color_code, only: [:update, :destroy, :detail_object_update]
  before_action :set_estimate_of_estimate_detail, only: [:edit, :update, :detail_object_update, :destroy]

  def edit
    @materials = Material.includes(:category_materials).where(plan_name_id: @estimate, category_materials: { category_id: @estimate_detail.category_id })
    @constructions = Construction.where(category_id: @estimate_detail.category_id)
    target_details = @estimate.estimate_details.where(category_id: @estimate_detail.category_id)
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
  end

  def destroy
    if params[:type] == "delete_category"
      estimate = @estimate_detail.estimate
      delete_details = estimate.estimate_details.where(category_id: @estimate_detail.category_id)
      delete_details.each do |details|
        details.destroy
      end
      @type = "delete_category"
    end
    if params[:type] == "delete_object"
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
    def set_estimate_detail
      @estimate_detail = EstimateDetail.find(params[:id])
    end

    def set_estimate_of_estimate_detail
      @estimate = @estimate_detail.estimate
    end
    
    def object_params
      params.require(:estimate_detail).permit(:name, :service_life, :price, :amount, :note)
    end
    
    # パラメーター整形
    def refactor_params_material_and_construction_ids
      if params[:estimate_detail][:material_ids].present?
        params_materials = params[:estimate_detail][:material_ids].split(",").map(&:to_i)
        @after_material_arrey = []
        params_materials.each do |params_material|
          unless params_material == 0
            @after_material_arrey << params_material
          end
        end
      end
      if params[:estimate_detail][:construction_ids].present?
        params_constructions = params[:estimate_detail][:construction_ids].split(",").map(&:to_i)
        @after_construction_arrey = []
        params_constructions.each do |params_construction|
          unless params_construction == 0
            @after_construction_arrey << params_construction
          end
        end
      end
    end
    
    # 差分調査
    def comparison
      if @after_material_arrey.present?
        before_material_arrey = @target_details_include_material.pluck(:material_id)
        # カテゴリが増えている場合
        if (@after_material_arrey - before_material_arrey) == [nil]
          @add_material_arrey = "nil"
        elsif @after_material_arrey == before_material_arrey
          @add_material_arrey = "nil"
        else
          @add_material_arrey = @after_material_arrey - before_material_arrey
        end
        # カテゴリが減っている場合
        if (before_material_arrey - @after_material_arrey) == [nil]
          @delete_material_arrey = "nil"
        elsif before_material_arrey == @after_material_arrey
          @delete_material_arrey = "nil"
        else
          @delete_material_arrey = before_material_arrey - @after_material_arrey
        end
      end
      
      if @after_construction_arrey.present?
        before_construction_arrey = @target_details_include_construction.pluck(:construction_id)
        # カテゴリが増えている場合
        if (@after_construction_arrey - before_construction_arrey) == [nil]
          @add_construction_arrey = "nil"
        elsif @after_construction_arrey == before_construction_arrey
          @add_construction_arrey = "nil"
        else
          @add_construction_arrey = @after_construction_arrey - before_construction_arrey
        end
        
        # カテゴリが減っている場合
        if (before_construction_arrey - @after_construction_arrey) == [nil]
          @delete_construction_arrey = "nil"
        elsif before_construction_arrey == @after_construction_arrey
          @delete_construction_arrey = "nil"
        else
          @delete_construction_arrey = before_construction_arrey - @after_construction_arrey
        end
      end
    end
    
    # 素材登録
    def register_materials(material_id_arrey)
      material_id_arrey.each.with_index(1) do |params_material_id, index|
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
    def decrease_materials(material_id_arrey)
      material_id_arrey.each do |material_id|
        objects = @estimate.estimate_details.where(material_id: material_id, category_id: @target_category)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    # 工事登録
    def register_constructions(construction_id_arrey)
      construction_id_arrey.each.with_index(1) do |params_construction_id, index|
        default_construction = Construction.find(params_construction_id)
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
    
    # 工事削除
    def decrease_constructions(construction_id_arrey)
      construction_id_arrey.each do |construction_id|
        objects = @estimate.estimate_details.where(construction_id: construction_id, category_id: @target_category)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    # 順番変更
    def change_order
      if @after_material_arrey.present?
        details_for_material = @estimate.estimate_details.where(category_id: @target_category).where.not(material_id: nil).sort_by{|detail| @after_material_arrey.index(detail.material_id)}
        # 素材内の順番変更
        basic_sort_number = details_for_material.first.sort_number
        details_for_material.each.with_index(1) do |detail, i|
          detail.update(sort_number: basic_sort_number + i)
        end
      end
      if @after_construction_arrey.present?
        details_for_construction = @estimate.estimate_details.where(category_id: @target_category).where.not(construction_id: nil).sort_by{|detail| @after_construction_arrey.index(detail.construction_id)}
        # 工事内の順番変更
        basic_sort_number = details_for_construction.first.sort_number
        details_for_construction.each.with_index(1) do |detail, i|
          detail.update(sort_number: detail.sort_number + i)
        end
      end
      # 見積全体の順番リセット
      @estimate.estimate_details.order(:sort_number).each.with_index(1) do |detail, i|
        detail.update(sort_number: i * 100)
      end
    end
end
