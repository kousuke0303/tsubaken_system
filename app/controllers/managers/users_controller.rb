class Managers::UsersController < ApplicationController
  before_action :authenticate_manager!, only: [:create, :destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :not_current_manager_return_login!
  
  def create
    @user = User.new(manager_user_params.merge(password: "user_password", password_confirmation: "user_password"))
    if @user.save
      ManagerUser.create!(manager_id: current_manager.id, user_id: @user.id)
      flash[:success] = "#{@user.name}を作成しました"
      redirect_to enduser_manager_url(current_manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
  end
  
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "#{@user.name}の情報を更新しました"
      if manager_signed_in?
        redirect_to enduser_manager_url(current_manager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @user.destroy
      flash[:success] = "#{@user.name}を削除しました"
      redirect_to enduser_manager_url(current_manager)
    end
  end
  
  private
    def manager_user_params
      params.require(:manager_user).permit(:id, :name, :email, :phone, :fax)
    end

    def user_params
      params.require(:user).permit(:id, :name, :email, :phone, :fax)
    end
    
    def set_user
      @user = User.find(params[:id])
    end
end
