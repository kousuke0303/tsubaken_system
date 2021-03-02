class Employees::Settings::Estimates::MaterialsController < Employees::Settings::EstimatesController
  before_action :set_material, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]
  

  def new
    @material = Material.new
    @categories_for_material = @categories.where(classification: 0)
                                          .or(@categories.where(classification: 2))
  end

  def create
    @material = Material.new(material_params.merge(default: true))
    if @material.save
      @responce = "success"
      @materials = Material.are_default
    else
      @responce = "failure"
    end
  end

  def edit
    @categories_for_material = @categories.where(classification: 0)
                                          .or(@categories.where(classification: 2))
  end

  def update
    if @material.estimate_details.present? && params[:material][:accept] != "1"
      @material.errors.add(:accept, "のチェック必須")
      @responce = "failure"
    else
      if @material.update(material_params)
        @responce = "success"
        @materials = Material.are_default
      else
        @responce = "failure"
      end
    end
  end

  def index
    @materials = Material.are_default
    if (@category_id = params[:category_id]).present?
      @materials = @materials.where(category_id: @category_id)
    end
    set_categories
  end

  def destroy
    unless @material.estimate_details.present? 
      @material.destroy
      @responce = "success"
    else
      @responce = "failure"
    end
    @materials = Material.are_default
  end

  private
    def material_params
      params.require(:material).permit(:name, :service_life, :unit, :price, :category_id)
    end

    def set_material
      @material = Material.find(params[:id])
    end
end

