class Employees::Settings::AttractMethodsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_attract_method, only: [:edit, :update, :destroy]

  def new
    @attract_method = AttractMethod.new
  end

  def create
    @attract_method = AttractMethod.new(attract_method_params)
    if @attract_method.save
      flash[:success] = "集客方法を作成しました。"
      redirect_to employees_settings_attract_methods_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @attract_method.update(attract_method_params)
      flash[:success] = "集客方法を更新しました。"
      redirect_to employees_settings_attract_methods_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @attract_methods = AttractMethod.all
  end

  def destroy
    @attract_method.destroy ? flash[:success] = "集客方法を削除しました。" : flash[:alert] = "集客方法を削除できませんでした。"
    redirect_to employees_settings_attract_methods_url
  end

  private
    def attract_method_params
      params.require(:attract_method).permit(:name)
    end

    def set_attract_method
      @attract_method = AttractMethod.find(params[:id])
    end
end
