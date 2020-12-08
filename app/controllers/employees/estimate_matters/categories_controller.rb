class Employees::EstimateMatters::CategoriesController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_category

  def edit
    @materials = Material.are_default
    @constructions = Construction.are_default
  end

  def update
  end

  def destroy
    @category.destroy
    @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    @estimates = @estimate_matter.estimates.with_categories
    respond_to do |format|
      format.js
    end
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end
end
