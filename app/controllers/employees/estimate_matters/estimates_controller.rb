class Employees::EstimateMatters::EstimatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimates_with_plan_names_and_label_colors, only: :index
  before_action :set_estimate_details, only: :index
  before_action :set_estimate, only: [:edit, :update, :copy, :destroy, :move]
  before_action :set_matter_of_estimate_matter, only: [:move, :copy]
  before_action :refactor_params_category_ids, only: [:create, :update]
  before_action :preview_display, only: :index
  
  def index
  end

  def new
    @estimate = @estimate_matter.estimates.new
    @categories = Category.order(position: :asc)
    @plan_names = PlanName.order(position: :asc)
  end

  # デフォルトのプラン名に合わせて、ラベルカラーをajaxで変更
  def change_label_color
    id = params[:id].to_i
    plan_name = PlanName.find(id)
    @sample_color = plan_name.label_color.color_code
  end

  def create
    @estimate = @estimate_matter.estimates.new(estimate_params)
    if @estimate.save
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if @after_category_array.present?
        params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
        params_categories.each.with_index(1) do |params_id, i|
          default_category = Category.find(params_id)
          @estimate.estimate_details.create!(category_name: default_category.name, category_id: params_id, sort_number: i * 100)
        end
      end
      @response = "success"
      set_estimates_with_plan_names_and_label_colors
      set_estimate_details
      set_matter_of_estimate_matter
    end
  end

  def edit
    @categories = Category.order(position: :asc)
    @plan_names = PlanName.order(position: :asc)
    @default_color = LabelColor.first.color_code
    # カテゴリ登録がすでにある場合
    if @estimate.estimate_details.present?
      estimate_details = @estimate.estimate_details.order(:sort_number)
      @estimate_details = estimate_details.group(:category_id)
      @type = "category_presence"
    # カテゴリがない場合
    else
      @type = "no_category"
    end
  end

  def update
    if @estimate.update(estimate_params)
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if @after_category_array.present?        
        comparison_for_category # 差分比較        
        # ①パターン：カテゴリ初登録及びカテゴリ増加        
        register_categories(@add_categories) if @add_category_array != "nil"        
        # ②パターン：カテゴリ削除      
        decrease_category(@delete_categories) if @delete_category_array != "nil"                
        change_category_order # 順番変更
      end
      @response = "success"
      @estimate.calc_total_price
      set_estimates_with_plan_names_and_label_colors
      set_estimate_details
    end
  end

  def destroy
    @estimate.destroy
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
  end

  # 見積複製アクション
  def copy
    new_estimate = @estimate.deep_dup
    new_estimate.save
    
    @estimate.estimate_details.each do |detail|
      new_detail = detail.deep_dup
      new_detail.estimate_id = new_estimate.id
      new_detail.save
    end
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
  end

  # 順番入替
  def move
    case params[:move]
    when "up"
      @estimate.move_higher
    when "down"
      @estimate.move_lower
    end
    set_estimates_with_plan_names_and_label_colors
    set_estimate_details
  end

  private
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def estimate_params
      params.require(:estimate).permit(:plan_name_id, :discount)
    end
    
    # パラメーター整形
    def refactor_params_category_ids
      params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
      # 空欄を除く
      @after_category_array = []
      params_categories.each do |params_categopry|      
        @after_category_array << params_categopry unless params_categopry == 0
      end
    end
    
    # 差分調査
    def comparison_for_category
      before_category_array = @estimate.estimate_details.pluck(:category_id)
      # カテゴリが増えている場合
      if (@after_category_array - before_category_array) == [nil] || @after_category_array == before_category_array
        @add_category_array = "nil"
      else
        @add_categories = @after_category_array - before_category_array
      end
      # カテゴリが減っている場合
      if (before_category_array - @after_category_array) == [nil] || before_category_array == @after_category_array
        @delete_category_array = "nil" 
      else
        @delete_categories = before_category_array - @after_category_array
      end
    end
    
    # カテゴリ登録
    def register_categories(category_id_array)
      before_detail_count = @estimate.estimate_details.count
      category_id_array.each.with_index(1) do |category_id, index|
        default_category = Category.find(category_id)
        @estimate.estimate_details.create(category_name: default_category.name,
                                          category_id: default_category.id,
                                          sort_number: before_detail_count + index)
      end
    end
    
    # カテゴリ減少
    def decrease_category(category_id_array)
      category_id_array.each do |category_id|
        @estimate.estimate_details.where(category_id: category_id).destroy_all
      end
    end
    
    # 順番変更
    def change_category_order
      details = @estimate.estimate_details.sort_by{|detail| @after_category_array.index(detail.category_id)}
      details.each.with_index(1) do |detail, i|
        detail.update(sort_number: i * 100)
      end
    end
end
