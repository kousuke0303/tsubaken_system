# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # POST /resource/sign_in
  def create
    super
  end

  def failed
    # warden で出力されたエラーを保存する
    flash[:alert] = "ログインに失敗しました"
    redirect_to root_path
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

  def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
    { scope: resource_name, recall: "#{controller_path}#failed" }
  end
  
  def after_sign_out_path_for(resource)
    root_url
  end 
end
