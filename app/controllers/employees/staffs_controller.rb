class Employees::StaffsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_staff, only: [:show, :edit, :update, :destroy]
  before_action :set_department, only: [:new, :create, :edit, :update]

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params.merge(password: "password", password_confirmation: "password"))
    if @staff.save
      flash[:success] = "スタッフを作成しました"
      redirect_to employees_staff_url(@staff)
    else
      render :new
    end
  end

  def index
    @staffs = Staff.all
  end

  def show
    @department_name = Department.find(@staff.department_id).name
  end

  def edit
  end

  def update
    if @staff.update(staff_params)
      flash[:success] = "スタッフ情報を更新しました"
      redirect_to employees_staff_url(@staff)
    else
      render :edit
    end
  end

  def destroy
    @staff.destroy ? flash[:success] = "スタッフを削除しました" : flash[:alert] = "スタッフを削除できませんでした"
    redirect_to employees_staffs_url
  end

  private
    def staff_params
      params.require(:staff).permit(:name, :login_id, :phone, :email, :birthed_on, :zipcode, :address, :department_id, :joined_on, :resigned_on)
    end

    def set_staff
      @staff = Staff.find(params[:id])
    end
    
    def set_department
      @departments = Department.all
    end
end
