class Manager::SubmanagersController < ApplicationController
  before_action :authenticate_manager!, only: [:create, :destroy]
  before_action :not_current_manager_return_login
  before_action :set_submanager, only: [:show, :edit, :update, :destroy]
  
  def create
    @submanager = current_manager.submanagers.build(submanager_params.merge(password: "password", password_confirmation: "password"))
    if @submanager.save
      flash[:success] = "SubManager#{@submanager.name}を登録しました"
      redirect_to employee_manager_url(current_manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
  end
  
  def update
    if @submanager.update_attributes(submanager_params)
      flash[:success] = "#{@submanager.name}の情報を更新しました"
      if manager_signed_in?
        redirect_to employee_manager_url(current_manager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @submanager.destroy
      flash[:success] = "#{@submanager.name}を削除しました"
      redirect_to employee_manager_url(current_manager)
    end
  end
  
  private
    def submanager_params
      params.require(:submanager).permit(:id, :name, :email, :password, :password_confirmation)
    end
    
    def set_submanager
      @submanager = current_manager.submanagers.find(params[:id])
    end
end
