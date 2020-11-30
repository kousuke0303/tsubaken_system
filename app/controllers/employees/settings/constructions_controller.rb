class Employees::Settings::ConstructionsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_construction, only: [:edit, :update, :destroy]

  def new
    @construction = Construction.new
  end

  def create
    @construction = Construction.new(construction_params)
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

  def index
    @constructions = Construction.all
  end

  def destroy
    @construction.destroy ? flash[:success] = "工事を削除しました。" : flash[:alert] = "工事を削除できませんでした。"
    redirect_to employees_settings_constructions_url
  end

  private
    def construction_params
      params.require(:construction).permit(:title)
    end

    def set_construction
      @construction = Construction.find(params[:id])
    end
end
