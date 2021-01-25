class Employees::EstimateMatters::EstimatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate, only: [:edit, :update, :copy, :destroy]
  before_action :refactor_params_category_ids, only: [:create, :update]
  
  def new
    @estimate = @estimate_matter.estimates.new
    @categories = Category.all
    @plan_names = PlanName.order(position: :asc)
  end

  def create
    @estimate = @estimate_matter.estimates.new(estimate_params)
    if @estimate.save
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if @after_category_arrey.present?
        params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
        params_categories.each.with_index(1) do |params_id, i|
          default_category = Category.find(params_id)
          @estimate.estimate_details.create!(category_name: default_category.name, category_id: params_id, sort_number: i * 100)
        end
      end
      @response = "success"
      @estimates = @estimate_matter.estimates
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @categories = Category.all
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
      if @after_category_arrey.present?
        # 差分比較
        comparison_for_category
        
        # ①パターン：カテゴリ初登録及びカテゴリ増加
        if @add_categories.present?
          register_categories(@add_categories)
        end
        
        # ②パターン：カテゴリ削除
        if @delete_categories.present?
          decrease_category(@delete_categories)
        end
        
        # 順番変更
        change_category_order
      end
      @response = "success"
      @estimates = @estimate_matter.estimates
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @estimate.destroy
    @estimates = @estimate_matter.estimates
  end

  # 見積複製アクション
  def copy
    new_estimate = @estimate_matter.estimates.create(title: @estimate.title)
    @estimate.categories.each do |category|
      new_category = new_estimate.categories.create(name: category.name, parent_id: category.parent_id)
      category.materials.each do |material|
        new_category.materials.create(name: material.name, service_life: material.service_life, price: material.price,
                                      unit: material.unit, amount: material.amount, total: material.total)
      end
      category.constructions.each do |construction|
        new_category.constructions.create(name: construction.name, price: construction.price, unit: construction.unit,
                                          amount: construction.amount, total: construction.total)
      end
    end
    set_estimates_details(@estimate_matter)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def estimate_params
      params.require(:estimate).permit(:title)
    end
    
    # パラメーター整形
    def refactor_params_category_ids
      params_categories = params[:estimate][:category_ids].split(",").map(&:to_i)
      # 空欄を除く
      @after_category_arrey = []
      params_categories.each do |params_categopry|
        unless params_categopry == 0
          @after_category_arrey << params_categopry
        end
      end
    end
    
    # 差分調査
    def comparison_for_category
      before_category_arrey = @estimate.estimate_details.pluck(:category_id)
      # カテゴリが増えている場合
      if (@after_category_arrey - before_category_arrey).present?
        @add_categories = @after_category_arrey - before_category_arrey
      end
      # カテゴリが減っている場合
      if (before_category_arrey - @after_category_arrey).present?
        @delete_categories = before_category_arrey - @after_category_arrey
      end
    end
    
    # カテゴリ登録
    def register_categories(category_id_arrey)
      before_detail_count = @estimate.estimate_details.count
      category_id_arrey.each.with_index(1) do |category_id, index|
        default_category = Category.find(category_id)
        @estimate.estimate_details.create(category_name: default_category.name,
                                          category_id: default_category.id,
                                          sort_number: before_detail_count + index)
      end
    end
    
    # カテゴリ減少
    def decrease_category(category_id_arrey)
      category_id_arrey.each do |category_id|
        objects = @estimate.estimate_details.where(category_id: category_id)
        objects.each do |object|
          object.destroy
        end
      end
    end
    
    def change_category_order
      sort_categories = @estimate.estimate_details.sort_by{|detail| @after_category_arrey.index(detail.category_id)}
      sort_categories.each.with_index(1) do |sort_category, i|
        sort_category.update(sort_number: i * 100)
      end
    end
end
