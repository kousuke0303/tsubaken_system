# frozen_string_literal: true

class Staffs::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  
  def failed
    # warden で出力されたエラーを保存する
    flash[:alert] = "ログインに失敗しました"
    redirect_to root_url
  end

  protected

    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    end
    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
end
