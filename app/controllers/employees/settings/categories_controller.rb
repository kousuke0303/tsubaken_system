class Employees::Settings::CategoriesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_category, only: [:edit, :update, :destroy]

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "見積書カテゴリを作成しました。"
      redirect_to employees_settings_categories_path
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = "見積書カテゴリを更新しました。"
      redirect_to employees_settings_categories_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @categories = Category.all
  end

  def destroy
    @category.destroy ? flash[:success] = "見積書カテゴリを削除しました。" : flash[:alert] = "見積書カテゴリを削除できませんでした。"
    redirect_to employees_settings_categories_url
  end

  private
    def category_params
      params.require(:category).permit(:title)
    end

    def set_category
      @category = Category.find(params[:id])
    end
end
