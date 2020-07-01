class User::UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :not_current_user_return_login!
  
  def top
    @user = current_user
  end
  
  def show
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。再度ログインしてください。"
      redirect_to root_url
    else
      render :edit
    end
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
    
end
