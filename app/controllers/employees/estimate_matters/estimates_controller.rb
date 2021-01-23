class Employees::EstimateMatters::EstimatesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_estimate, only: [:edit, :update, :copy, :destroy]

  def new
    @estimate = @estimate_matter.estimates.new
    @categories = Category.all.where(default: true)
  end

  def create
    @estimate = @estimate_matter.estimates.new(estimate_params)
    if @estimate.save
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if params[:estimate]["category_ids"].present?
        params_categories = params[:estimate]["category_ids"].split(",")
        params_categories.each.with_index(1) do |category_id, i|
          default_category = Category.find(category_id)
          @estimate.categories.create(name: default_category.name, parent_id: default_category.id, sort_number: i)
        end
      end
      @response = "success"
      @estimates = @estimate_matter.estimates.with_categories
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def edit
    @categories = Category.all.where(default: true)
    @estimate_categories = @estimate.categories.all
  end

  def update
    if @estimate.update(estimate_params)
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if params[:estimate]["category_ids"].present?
        prerequisite_processing_for_update
        # 増加カテゴリの処理
        if @add_categories.present?
          @add_categories.each do |category_id|
            default_category = Category.find(category_id)
            @estimate.categories.create(name: default_category.name, parent_id: default_category.id)
          end
        end
        # 現象カテゴリの処理
        if @delete_categories.present?
          @delete_categories.each do |category_id|
            object = Category.where(parent_id: category_id).find_by(estimate_id: @estimate.id)
            object.destroy
          end
        end
        # 順番変更
        change_category_order
      end
      @response = "success"
      set_estimates_details(@estimate_matter)
    else
      @response = "false"
    end
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @estimate.destroy
    set_estimates_details(@estimate_matter)
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
    
    def prerequisite_processing_for_update
      # カテゴリの差分
      before_category_arrey = @estimate.categories.pluck(:parent_id)
      params_categories = params[:estimate]["category_ids"].split(",").map(&:to_i)
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
      sort_categories = @estimate.categories.sort_by{|category| @after_category_arrey.index(category.parent_id)}
      sort_categories.each.with_index(1) do |sort_category, i|
        sort_category.update(sort_number: i)
      end
    end
end
