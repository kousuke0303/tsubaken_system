# frozen_string_literal: true

class ExternalStaffs::SessionsController < Devise::SessionsController
  def failed
    # warden で出力されたエラーを保存する
    flash[:alert] = "ログインに失敗しました。"
    redirect_to root_url
  end

  protected    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
    
    # application_controllerのbefore_action回避
    def use_before_action?
      false
    end
end
