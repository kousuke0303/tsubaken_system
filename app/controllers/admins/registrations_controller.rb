# frozen_string_literal: true

class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin!
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    @admin = Admin.find(current_admin.id)
    if @admin.update(admin_params)
      sign_in(@admin, :bypass => true)
      flash[:success] = "アカウント情報を更新しました"
      redirect_to top_admin_url(@admin)
    else
      render :edit
    end
  end

  private
   def admin_params
     params.require(:admin).permit(:name, :employee_id, :password, :password_confirmation)
   end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :employee_id])
  end

  # def after_update_path_for(resource)
  #   admin_top_path
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :employee_id])
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
