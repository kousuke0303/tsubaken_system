# frozen_string_literal: true

class Clients::SessionsController < Devise::SessionsController
  after_action :reset_tem_password, only: :create

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
