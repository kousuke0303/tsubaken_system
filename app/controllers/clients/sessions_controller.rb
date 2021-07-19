# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  after_action :reset_tem_password, only: :create
  
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    if current_client.present? && params[:instance_id]
      @user_device = current_client.member_code.user_devices.new(instance_id: params[:instance_id])
      @user_device.save
    end
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end
  
  def failed
    # warden で出力されたエラーを保存する
    flash[:alert] = "ログインに失敗しました。"
    redirect_to root_path
  end

  protected
    def auth_options
      # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
      # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
    
    # ログイン成功時、仮パスワードがあればnilに更新
    def reset_tem_password
      resource.update(tmp_password: nil) if resource.tmp_password.present?
    end
end
