class Employees::Settings::AttractMethodsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_attarct_method, only: [:edit, :update, :destroy]

  def new
    @attarct_method = AttarctMethod.new
  end

  def create
    @attarct_method = AttarctMethod.new(attarct_method_params)
    if @attarct_method.save
      flash[:success] = "集客方法を作成しました。"
      redirect_to employees_settings_attarct_methods_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @attarct_method.update(attarct_method_params)
      flash[:success] = "集客方法を更新しました。"
      redirect_to employees_settings_attarct_methods_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @attarct_methods = AttarctMethod.all
  end

  def destroy
    @attarct_method.destroy ? flash[:success] = "集客方法を削除しました。" : flash[:alert] = "集客方法を削除できませんでした。"
    redirect_to employees_settings_attarct_methods_url
  end

  private
    def attarct_method_params
      params.require(:attarct_method).permit(:name)
    end

    def set_attarct_method
      @attarct_method = AttarctMethod.find(params[:id])
    end
end
