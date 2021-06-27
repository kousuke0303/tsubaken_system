# frozen_string_literal: true

class Managers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_manager!
  before_action :set_departments, only: :edit

  def edit
  end

  def update
    @manager = Manager.find(current_manager.id)
    if params[:manager][:password].blank? && params[:manager][:password_confirmation].blank?
      params[:manager].delete(:password)
      params[:manager].delete(:password_confirmation)
    end
    if @manager.update(manager_params)
      bypass_sign_in(@manager)
      flash[:alert] = "アカウント情報を更新しました"
      redirect_to managers_top_url
    else
      render :edit
    end
  end
  
  private
    def manager_params
      params.require(:manager).permit(:name, :login_id, :phone, :email, :birthed_on, :postal_code, :prefecture_code, :address_city, :address_street, :department_id, :joined_on, :resigned_on, :password, :password_confirmation)
    end
end
