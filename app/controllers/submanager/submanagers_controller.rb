class Submanager::SubmanagersController < ApplicationController
  before_action :authenticate_submanager!, only: [:top, :show, :edit, :update]
  helper_method :current_submanager_company
  
  def top
    @submanager = current_submanager
  end
  
  def show
  end
  
  def edit
    @submanager = current_submanager
  end
  
  def update
    @submanager = current_submanager
    if @submanager.update_attributes(submanager_params)
      flash[:success] = "アカウント情報を更新しました。再度ログインしてください。"
      redirect_to root_url
    else
      render :edit
    end
  end

  def enduser
    @submanager = Submanager.find(params[:id])
  end
  
  private
    def submanager_params
      params.require(:submanager).permit(:name, :email, :password, :password_confirmation)
    end
    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
    
end
