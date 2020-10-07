# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin!
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def update
    @admin = Admin.find(current_admin.id)
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].delete(:password)
      params[:admin].delete(:password_confirmation)
    end
    if @admin.update(admin_params)
      sign_in(@admin, :bypass => true)
      flash[:alert] = "アカウント情報を更新しました"
      redirect_to top_admin_url(@admin)
    else
      render :edit
    end
  end

  protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :login_id])
    end

    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :login_id])
    end

  private
    def admin_params
      params.require(:admin).permit(:name, :login_id, :password, :password_confirmation)
    end
end
