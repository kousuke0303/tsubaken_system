# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin!
  
  def update
    @admin = Admin.find(current_admin.id)
    if params[:admin][:password].blank? && params[:admin][:password_confirmation].blank?
      params[:admin].delete(:password)
      params[:admin].delete(:password_confirmation)
    end
    if @admin.update(admin_params)
      bypass_sign_in(@admin)
      flash[:notice] = "アカウント情報を更新しました。"
      redirect_to edit_admin_registration_url
    else
      flash.now[:alert] = "パスワード更新に失敗しました"
      render :edit
    end
  end

  private
    def admin_params
      params.require(:admin).permit(:name, :login_id, :email, :phone, :password, :password_confirmation)
    end
end
