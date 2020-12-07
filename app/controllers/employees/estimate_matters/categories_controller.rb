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
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end
end
