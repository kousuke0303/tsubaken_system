class Admin::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :only_admin!
  before_action :admin_limit_1
  
  def index
    @account_number = Manager.count
    @non_approval_managers = Manager.where(approval: false)
    @managers = Manager.where(approval: true)
  end
  
  def approval
    @manager = Manager.find(params[:id])
    if @manager.update(approval_params.merge(approval: true))
      flash[:success] = "#{@manager.company}を承認しました"
      redirect_to admin_managers_url
    else
      flash[:alert] = "承認に失敗しました"
      redirect_to admin_managers_url
    end
  end
  
  def non_approval
     @manager = Manager.find(params[:id])
    if @manager.update(approval: false)
      flash[:success] = "#{@manager.company}を未承認にしました"
      redirect_to admin_managers_url
    else
      flash[:alert] = "承認変更に失敗しました"
      redirect_to admin_managers_url
    end
  end
  
  def destroy
     @manager = Manager.find(params[:id])
    if @manager.destroy
      flash[:success] = "#{@manager.company}を削除しました"
      redirect_to admin_managers_url
    else
      flash[:alert] = "削除に失敗しました"
      redirect_to admin_managers_url
    end
  end
  
  private
    def approval_params
      params.require(:manager).permit(:public_uid)
    end
  
end
