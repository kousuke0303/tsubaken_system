# frozen_string_literal: true

class SupplierManagers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_supplier_manager!

  def edit
    @supplier = current_supplier_manager.supplier
    @industries = Industry.order(position: :asc)
  end
  
  def update
    @supplier_manager = current_supplier_manager
    if params[:supplier_manager][:password].blank? && params[:supplier_manager][:password_confirmation].blank?
      params[:supplier_manager].delete(:password)
      params[:supplier_manager].delete(:password_confirmation)
    end
    if @supplier_manager.update(supplier_manager_params)
      sign_in(@supplier_manager, :bypass => true)
      flash[:notice] = "アカウント情報を更新しました。"
      redirect_to top_supplier_managers_path
    else
      render :edit
    end
  end
  
  private
    def supplier_manager_params
      params.require(:supplier_manager).permit(:name, :login_id, :email, :phone, :password, :password_confirmation)
    end
  
  
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
