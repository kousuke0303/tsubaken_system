class Employees::Settings::MaterialsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_material, only: [:edit, :update, :destroy]

  def new
    @material = Material.new
  end

  def create
    @material = Material.new(material_params.merge(default: true))
    if @material.save
      flash[:success] = "素材を作成しました。"
      redirect_to employees_settings_materials_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @material.update(material_params)
      flash[:success] = "素材を更新しました。"
      redirect_to employees_settings_materials_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @materials = Material.are_default
  end

  def destroy
    @material.destroy ? flash[:success] = "素材を削除しました。" : flash[:alert] = "素材を削除できませんでした。"
    redirect_to employees_settings_materials_url
  end

  private
    def material_params
      params.require(:material).permit(:name, :service_life, :unit, :price, :category_id)
    end

    def set_material
      @material = Material.find(params[:id])
    end
end
