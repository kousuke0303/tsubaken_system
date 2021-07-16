# frozen_string_literal: true

class Managers::SessionsController < Devise::SessionsController
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    if current_manager.present? && params[:instance_id]
      @user_device = current_manager.member_code.user_devices.new(instance_id: params[:instance_id])
      @user_device.save
    end
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  
  def failed
    # warden で出力されたエラーを保存する
    flash[:alert] = "ログインに失敗しました"
    redirect_to root_url
  end

  protected    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{ controller_path }#failed" }
    end
end
