class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!, except: :unapproval_top
  before_action :unapproval_manager_show, except: :unapproval_top
  before_action :not_current_manager_return_login!
  before_action :set_one_month, only: :top
  
  def show
    @manager = Manager.find(current_manager.id)
  end
  
  def unapproval_top
    non_approval_layout
    @manager = Manager.find(params[:id])
  end
  
  def top
    @manager = Manager.find(current_manager.id)
  end
  
  def employee
    @staff = dependent_manager.staffs.build
    @staff.manager_staffs.build
  end
  
  def employee_type
    @manager = Manager.find_by(public_uid: params[:id])
    @employee_type = params[:employee_type]
    respond_to do |format|
      format.js
      format.any
    end
  end

  def enduser
    @manager = Manager.find_by(public_uid: params[:id])
  end
  
  private
    
    # 承認されていないManagerのページに遷移
    def unapproval_manager_show
      unless current_manager.approval
        redirect_to manager_signup_manager_manager_url
      end
    end
end
