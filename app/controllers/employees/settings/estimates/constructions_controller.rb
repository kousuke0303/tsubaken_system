class Employees::Settings::Estimates::ConstructionsController < Employees::Settings::EstimatesController
  before_action :set_construction, only: [:edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]
  
  def index
    @constructions = Construction.includes_category
  end
  
  def new
    @construction = Construction.new
    @categories_for_construction = @categories.where(classification: 0)
                                              .or(@categories.where(classification: 1))
  end

  def create
    @construction = Construction.new(construction_params.merge(default: true))
    if @construction.save
      @responce = "success"
      @constructions = Construction.includes_category
    else
      @responce = "failure"
    end
  end
  
  def edit
    @categories_for_construction = @categories.where(classification: 0)
                                              .or(@categories.where(classification: 1))
  end

  def update
    if @construction.estimate_details.present? && params[:construction][:accept] != "1"
      @construction.errors.add(:accept, "のチェック必須")
      @responce = "failure"
    else
      if @construction.update(construction_params)
        @responce = "success"
        @constructions = Construction.includes_category
      else
        @responce = "failure"
      end
    end
  end

  def destroy
    unless @construction.estimate_details.present? 
      @construction.destroy
      @responce = "success"
    else
      @responce = "failure"
    end
    @constructions = Construction.includes_category
  end

  private
    def set_construction
      @construction = Construction.find(params[:id])
    end

    def construction_params
      params.require(:construction).permit(:name, :unit, :price, :category_id)
    end
end
