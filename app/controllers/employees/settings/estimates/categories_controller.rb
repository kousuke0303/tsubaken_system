class Employees::Settings::Estimates::CategoriesController < Employees::Settings::EstimatesController
  before_action :set_category, only: [:edit, :update, :destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      @responce = "success"
    else
      @responce = "failure"
    end
    set_categories  
  end

  def edit
  end

  def update
    if @category.estimate_details.present? && params[:category][:accept] != "1"
      @category.errors.add(:accept, "のチェック必須")
      @responce = "failure"
    else
      if @category.update(category_params)
        @responce = "success"
        set_categories
      else
        @responce = "failure"
      end
    end
  end

  def destroy
    unless @category.estimate_details.present? 
      @category.destroy
      @responce = "success"
    else
      @responce = "failure"
    end
    set_categories 
  end

  def sort
    from = params[:from].to_i + 1
    category = Category.find_by(position: from)
    category.insert_at(params[:to].to_i + 1)
    set_categories
  end

  private
    def category_params
      params.require(:category).permit(:name, :classification)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
