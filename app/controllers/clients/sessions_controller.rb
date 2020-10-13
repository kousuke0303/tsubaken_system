# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    client = Client.find_by(login_id: params[:session][:login_id])
    if client && client.authenticate(params[:session][:password])
      log_in client
      params[:session][:remember_me] == "1" ? remember(client) : forget(client)
      redirect_back_or client
    else
      flash[:danger] = "認証に失敗しました。"
      render :new
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
