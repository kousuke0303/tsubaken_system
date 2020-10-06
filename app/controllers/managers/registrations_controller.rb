# frozen_string_literal: true

class Managers::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_manager!
  before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    @manager = Manager.new
  end

  # POST /resource
  def create
    @manager = Manager.new(manager_params)
    if @manager.save
      redirect_to manager_url(@manager)
    else
      render :new
    end
  end

  # GET /resource/edit
  # def edit
  # end

  # PUT /resource
  def update
    @manager = Manager.find(current_manager.id)
    if @manager.update(manager_params)
      sign_in(@manager, :bypass => true)
      flash[:success] = "アカウント情報を更新しました."
      redirect_to top_manager_url(@manager)
    else
      render :edit
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end
  
  private
   def manager_params
     params.require(:manager).permit(:name, :employee_id, :phone, :email, :zip_code, :address, :joined_on, :resigned_on, :password, :password_confirmation)
   end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:employee_id])
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  # devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
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
