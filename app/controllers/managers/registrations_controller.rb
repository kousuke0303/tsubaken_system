# frozen_string_literal: true

class Managers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_manager!

  def update
    @manager = Manager.find(current_manager.id)
    if params[:manager][:password].blank? && params[:manager][:password_confirmation].blank?
      params[:manager].delete(:password)
      params[:manager].delete(:password_confirmation)
    end
    if @manager.update(manager_params)
      sign_in(@manager, :bypass => true)
      flash[:alert] = "アカウント情報を更新しました"
      redirect_to top_manager_url(@manager)
    else
      render :edit
    end
  end
  
  private
    def manager_params
      params.require(:manager).permit(:name, :employee_id, :phone, :email, :birthed_on, :zip_code, :address, :joined_on, :resigned_on, :password, :password_confirmation)
    end
end
