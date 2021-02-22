class Employees::Settings::CategoriesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_categories, only: :index
  before_action :set_category, only: [:edit, :update, :destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "工事名称を作成しました。"
      redirect_to employees_settings_categories_url
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = "工事名称を更新しました。"
      redirect_to employees_settings_categories_url
    end
  end

  def index
  end

  def destroy
    @category.destroy ? flash[:success] = "工事名称を削除しました。" : flash[:alert] = "工事名称を削除できませんでした。"
    redirect_to employees_settings_categories_url
  end

  def sort
    from = params[:from].to_i + 1
    category = Category.find_by(position: from)
    category.insert_at(params[:to].to_i + 1)
    set_categories
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
