class Submanager::StaffsController < ApplicationController
  before_action :authenticate_submanager!, only: [:top, :create, :show, :edit, :update, :destroy, :outsourcing_staff_destroy]
  helper_method :current_submanager_company
  before_action :set_staff, only: [:show, :edit, :update, :destroy, :outsourcing_staff_destroy]
  
  def top
    @staff = current_staff
  end
  
  def show
  end
  
  def edit
    @manager_staff = dependent_manager.manager_staffs.find_by(staff_id: @staff.id)
  end

  def create
    @staff = Staff.new(manager_staff_params.merge(password: "staff_password", password_confirmation: "staff_password"))
    if @staff.save
      ManagerStaff.create!(manager_id: current_submanager.manager_id, staff_id: @staff.id)
      flash[:success] = "#{@staff.name}を作成しました"
      redirect_to employee_submanager_url(current_submanager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def update
    if @staff.update_attributes(staff_params)
      flash[:success] = "#{@staff.name}の情報を更新しました"
      redirect_to employee_submanager_url(dependent_manager, current_submanager)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @staff.destroy
      flash[:success] = "#{@staff.name}を削除しました"
      redirect_to employee_submanager_url(dependent_manager, current_submanager)
    end
  end
  
  def outsourcing_staff_destroy
    manager_staff = dependent_manager.manager_staffs.find_by(staff_id: @staff.id)
    manager_staff.destroy
    flash[:success] = "#{@staff.name}を削除しました"
    redirect_to employee_submanager_url(dependent_manager, current_submanager)
  end

  def enduser
  end

  def employee
    @staff = Staff.find(params[:id])
  end
  
  private

    def set_staff
      @staff = Staff.find(params[:id])
    end

    def manager_staff_params
      params.require(:manager_staff).permit(:id, :name, :email, :phone)
    end

    def staff_params
      params.require(:staff).permit(:id, :name, :email, :phone)
    end
    
    def auth_options
    # 失敗時に recall に設定したパスのアクションが呼び出されるので変更
    # { scope: resource_name, recall: "#{controller_path}#new" } # デフォルト
      { scope: resource_name, recall: "#{controller_path}#failed" }
    end
end
