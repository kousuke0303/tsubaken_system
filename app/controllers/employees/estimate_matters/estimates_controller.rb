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
        params[:estimate]["category_ids"].each do |category_id|
          default_category = Category.find(category_id)
          @estimate.categories.create(name: default_category.name, parent_id: default_category.id)
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
  end

  def update
    if @estimate.update(estimate_params)
      # 送られてきたデフォルトカテゴリを、見積の持つカテゴリとしてコピー
      if params[:estimate]["category_ids"].present?
        params[:estimate]["category_ids"].each do |category_id|
          default_category = Category.find(category_id)
          @estimate.categories.create(name: default_category.name, parent_id: default_category.id)
        end
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
end
