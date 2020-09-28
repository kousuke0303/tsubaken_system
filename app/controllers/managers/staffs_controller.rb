class Managers::StaffsController < ApplicationController
  before_action :authenticate_manager!, only: [:create, :destroy]
  before_action :not_current_manager_return_login!
  before_action :set_staff, only: [:show, :edit, :update, :destroy, :outsourcing_staff_destroy]
  
  def create
    @staff = Staff.new(staff_params.merge(password: "staff_password", password_confirmation: "staff_password"))
    if @staff.save
      flash[:success] = "Staff#{@staff.name}を登録しました"
      redirect_to employee_manager_url(current_manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
    @manager_staff = current_manager.manager_staffs.find_by(staff_id: @staff.id)
  end
  
  def update
    if @staff.update_attributes(staff_params)
      flash[:success] = "#{@staff.name}の情報を更新しました"
      if manager_signed_in?
        redirect_to employee_manager_url(current_manager)
      end
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def destroy
    if @staff.destroy
      flash[:success] = "#{@staff.name}を削除しました"
      redirect_to employee_manager_url(current_manager)
    end
  end
  
  def outsourcing_staff_destroy
    manager_staff = dependent_manager.manager_staffs.find_by(staff_id: @staff.id)
    manager_staff.destroy
    flash[:success] = "#{@staff.name}を削除しました"
    redirect_to employee_manager_url(current_manager)
  end
  
  private

    def staff_params
      params.require(:staff).permit(:id, :name, :email, manager_staffs_attributes: [:id, :manager_id, :employee])
    end
    
    def set_staff
      @staff = Staff.find(params[:id])
    end
end
