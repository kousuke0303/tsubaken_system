class Employees::Matters::AdoptedEstimatesController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_categories, only: :edit
  before_action :set_plan_names, only: :edit
  before_action :set_default_color_code, only: :edit
  before_action :set_matter_by_matter_id
  before_action :set_adopted_estimate
  before_action :refactor_params_category_ids, only: :update

  def edit
    @color_code = @adopted_estimate.plan_name.label_color.color_code
    # カテゴリ登録がすでにある場合
    if @adopted_estimate.adopted_estimate_details.present?
      @adopted_estimate_details = @adopted_estimate.adopted_estimate_details.order(:sort_number).group(:category_id)
      @type = "category_presence"
    # カテゴリがない場合
    else
      @type = "no_category"
    end
  end

  def update
    if @adopted_estimate.update(adopted_estimate_params)
      if @after_category_array.present?
        comparison_for_category # 差分比較
        # ①パターン：カテゴリ初登録及びカテゴリ増加        
        register_categories(@add_categories) if @add_categories != "nil"        
        # ②パターン：カテゴリ削除
        decrease_category(@delete_categories) if @delete_categories != "nil"              
        # 順番変更
        change_category_order
      end
      @response = "success"
      @adopted_estimate.calc_total_price
      set_plan_name_and_label_color_of_adopted_estimate
      set_adopted_estimate_details
    end
  end

  def destroy
  end

  private
    def set_adopted_estimate
      @adopted_estimate = AdoptedEstimate.find(params[:id])
    end

    def adopted_estimate_params
      params.require(:adopted_estimate).permit(:plan_name_id, :discount)
    end

    # パラメーター整形
    def refactor_params_category_ids
      params_categories = params[:adopted_estimate][:category_ids].split(",").map(&:to_i)
      @after_category_array = []
      params_categories.each do |params_categopry|
        @after_category_array << params_categopry unless params_categopry == 0
      end
    end

    # 差分調査
    def comparison_for_category
      before_category_array = @adopted_estimate.adopted_estimate_details.pluck(:category_id)
      # カテゴリが増えている場合
      (@after_category_array - before_category_array) == [nil] || @after_category_array == before_category_array ?
      @add_category_array = "nil" : @add_categories = @after_category_array - before_category_array      
      # カテゴリが減っている場合
      (before_category_array - @after_category_array) == [nil] || before_category_array == @after_category_array ?
      @delete_category_array = "nil" : @delete_categories = before_category_array - @after_category_array
    end

    # カテゴリ登録
    def register_categories(category_id_array)
      before_detail_count = @adopted_estimate.adopted_estimate_details.count
      category_id_array.each.with_index(1) do |category_id, index|
        default_category = Category.find(category_id)
        @adopted_estimate.adopted_estimate_details.create(category_name: default_category.name,
                                                          category_id: default_category.id,
                                                          sort_number: before_detail_count + index)
      end
    end

    # カテゴリ減少
    def decrease_category(category_id_array)
      category_id_array.each do |category_id|
        @adopted_estimate.adopted_estimate_details.where(category_id: category_id).destroy_all
      end
    end
end
