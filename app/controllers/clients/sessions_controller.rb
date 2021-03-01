# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  def create
    self.resource = warden.authenticate!(auth_options)
    if self.resource.confirmed
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash[:alert] = "ログインに失敗しました。"
      self.resource = nil
      redirect_to root_path
    end
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
end
