class Staff::StaffsController < ApplicationController
  before_action :authenticate_staff!
  
  def top
    @staff = current_staff
  end
  
  def show
  end
  
  def edit
    @staff = current_staff
  end
  
  def update
    @staff = current_staff
    if @staff.update_attributes(staff_params)
      flash[:success] = "アカウント情報を更新しました。再度ログインしてください。"
      redirect_to root_url
    else
      render :edit
    end
  end
  
  private
    def staff_params
      params.require(:staff).permit(:name, :email, :password, :password_confirmation)
    end
    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
end
