class Employees::Settings::ConstructionsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_construction, only: [:edit, :update, :destroy]

  def index
    @constructions = Construction.are_default
    if (@category_id = params[:category_id]).present?
      @constructions = @constructions.where(category_id: @category_id)
    end
    @categories = Category.all
  end

  def new
    @construction = Construction.new
  end

  def create
    @construction = Construction.new(construction_params.merge(default: true))
    if @construction.save
      flash[:success] = "工事を作成しました。"
      redirect_to employees_settings_constructions_url
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
  end

  def update
    if @construction.update(construction_params)
      flash[:success] = "工事を更新しました。"
      redirect_to employees_settings_constructions_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @construction.destroy ? flash[:success] = "工事を削除しました。" : flash[:alert] = "工事を削除できませんでした。"
    redirect_to employees_settings_constructions_url
  end

  private
    def set_construction
      @construction = Construction.find(params[:id])
    end

    def construction_params
      params.require(:construction).permit(:name, :unit, :price, :category_id)
    end
end
