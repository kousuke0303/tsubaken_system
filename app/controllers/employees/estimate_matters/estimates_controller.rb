class Employees::EstimateMatters::EstimatesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter
  before_action :set_estimate, only: [:destroy]

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

  def show
  end

  def edit
  end

  def update
    if @estimate.update(estimate_params)
      flash[:success] = "見積を作成しました。"
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @estimate.destroy
    @estimates = @estimate_matter.estimates.with_categories
  end

  private
    def set_estimate
      @estimate = Estimate.find(params[:id])
    end

    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end

    def estimate_params
      params.require(:estimate).permit(:title)
    end
end
