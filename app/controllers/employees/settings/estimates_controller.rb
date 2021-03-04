class Employees::Settings::EstimatesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_categories, only: [:index, :search_category]
  
  def index
    @plan_names = PlanName.with_colors
    @constructions = Construction.includes_category
    @categories_for_construction = @categories.where(classification: 0)
                                              .or(@categories.where(classification: 1))
    @materials = Material.include_category
    @categories_for_material = @categories.where(classification: 0)
                                          .or(@categories.where(classification: 2))
  end
  
  def search_category
    if params[:classification].present? && params[:classification] != "99"
      @categories = @categories.where(classification: params[:classification])
    end
  end
  
  def search_construction
    @constructions = Construction.are_default
    if (@category_id = params[:category_id]).present?
      @constructions = @constructions.where(category_id: @category_id)
    end
  end
  
  def search_material
    @materials = Material.are_default
    if (@category_id = params[:category_id]).present?
      @materials = @materials.where(categories: { id: @category_id })
    end
  end
end
