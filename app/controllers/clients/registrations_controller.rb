# frozen_string_literal: true

class Clients::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_client!
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def update
    @client = Client.find(current_client.id)
    if params[:client][:password].blank? && params[:client][:password_confirmation].blank?
      params[:client].delete(:password)
      params[:client].delete(:password_confirmation)
    end
    if @client.update(client_params)
      sign_in(@client, :bypass => true)
      flash[:alert] = "アカウント情報を更新しました"
      redirect_to top_client_url(@client)
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
    def client_params
      params.require(:client).permit(:name, :login_id, :password, :password_confirmation)
    end
end
