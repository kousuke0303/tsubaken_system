class Staffs::StaffsController < ApplicationController
  before_action :authenticate_staff!
  before_action :not_current_staff_return_login!  

  def top
  end
  
  private
    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
end
