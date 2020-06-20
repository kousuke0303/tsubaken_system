class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_submanager_public_uid
  helper_method :current_matter
  
  # login画面等のデザインformat指定
  def non_approval_layout
    @type = "log_in"
  end
  
  # ---------------ADMIN関係----------------------------------
  
  # 管理者権限者が一人に以上の場合、管理者画面お表示で知らせる。
  def admin_limit_1
    if Admin.count > 1
      @condition = "danger"
    else
      @condition = "dark"
    end
  end
  
  # アクセス制限
  def only_admin!
    unless Admin.first.id == current_admin.id 
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_path
    end
  end
  
  # ---------------MATTER関係----------------------------------
  
  def current_matter
    Matter.find_by(matter_uid: params[:id])
  end
  
  def matter_authenticate!
    if current_manager && current_manager.public_uid == params[:manager_public_uid]
      return true
    elsif current_submanager && current_submanager.manager.public_uid == params[:manager_public_uid]
      return true
    else
      flash[:alert] = "アクセス権限がありません"
      redirect_to root_url
    end
  end
  
  def only_show_authenticate!
    if current_manager && current_manager.public_uid == params[:manager_public_uid]
      @matters = current_manager.matters
    elsif current_submanager && current_submanager.manager.public_uid == params[:manager_public_uid]
      @matters = current_submanager.manager.matters
    elsif current_staff
      @matters = current_staff.matters
    end
  end
    
  private
  
  # ログイン後のリダイレクト先
    def current_submanager_public_uid
      current_submanager.manager.public_uid
    end
   
  
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(Admin)
        top_admin_admin_path(current_admin)
      elsif resource_or_scope.is_a?(Manager)
        top_manager_path(current_manager)
      elsif resource_or_scope.is_a?(Submanager)
        top_submanager_path(current_submanager_public_uid, current_submanager)
      elsif resource_or_scope.is_a?(Staff)
        top_staff_path(current_staff)
      elsif resource_or_scope.is_a?(User)
        top_user_path(current_user)
      else
        root_path
      end
    end
end
