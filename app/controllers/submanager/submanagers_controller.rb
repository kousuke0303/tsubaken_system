class Submanager::SubmanagersController < ApplicationController
  before_action :authenticate_submanager!, only: [:top, :show, :edit, :update]
  before_action :not_current_submanager_return_login!
  before_action :return_login
  helper_method :current_submanager_company
  
  def top
    @attendance = current_submanager.attendances.build
    @today_attendance = current_submanager.attendances.find_by(worked_on: Date.today)
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
  
  def employee
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
    
    # to_paramを変更した事による是正
    def return_login
      unless params[:manager_public_uid] == dependent_manager.public_uid
        flash[:alert] = "アクセス権限がありません"
        redirect_to root_path
      end
    end
end
