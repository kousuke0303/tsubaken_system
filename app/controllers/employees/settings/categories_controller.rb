class Employees::Settings::CategoriesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_category, only: [:edit, :update, :destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params.merge(default: true))
    if @category.save
      flash[:success] = "工事カテゴリを作成しました。"
      redirect_to employees_settings_categories_url
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = "工事カテゴリを更新しました。"
      redirect_to employees_settings_categories_url
    end
  end

  def index
    @categories = Category.all.where(default: true)
  end

  def destroy
    @category.destroy ? flash[:success] = "工事カテゴリを削除しました。" : flash[:alert] = "工事カテゴリを削除できませんでした。"
    redirect_to employees_settings_categories_url
  end

  private
    def category_params
      params.require(:category).permit(:name)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
