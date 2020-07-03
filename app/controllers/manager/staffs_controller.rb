class Manager::StaffsController < ApplicationController
  before_action :authenticate_manager!, only: [:create, :destroy]
  before_action :not_current_manager_return_login!
  before_action :set_staff, only: [:show, :edit, :update, :destroy]
  before_action :manager_event_title
  
  def create
    @staff = Staff.new(staff_params.merge(password: "staff_password", password_confirmation: "staff_password"))
    if @staff.save
      @staff.manager_staffs.create!(manager_id: current_manager.id)
      flash[:success] = "Staff#{@staff.name}を登録しました"
      redirect_to employee_manager_url(current_manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def edit
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
  
  private

    def staff_params
      params.require(:staff).permit(:id, :name, :email)
    end
    
    def set_staff
      @staff = Staff.find(params[:id])
    end
end
