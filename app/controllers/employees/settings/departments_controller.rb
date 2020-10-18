class Employees::Settings::DepartmentsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_department, only: [:show, :edit, :update, :destroy]
  
  def new
    @department = Department.new
  end
  
  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "部署を作成しました"
      redirect_to employees_settings_department_path(@department)
    else
      flash[:danger] = "部署の作成に失敗しました"
      render :new
    end
  end

  def show
  end

  def index
    @departments = Department.all
  end

  def edit
  end

  def update
    if @department.update(department_params)
      flash[:success] = "部署情報を更新しました"
      redirect_to employees_settings_department_path(@department)
    else
      render :edit
    end
  end

  def destroy
    @manager_dept_ids = Manager.pluck(:department_id)
    @staff_dept_ids = Staff.pluck(:department_id)
    if @manager_dept_ids.none?{|i| i  == @department.id}  && @staff_dept_ids.none?{|i| i  == @department.id}
      @department.destroy ? flash[:success] = "部署を削除しました" : flash[:alert] = "部署を削除できませんでした"
    else
      flash[:alert] = "#{@department.name}は使用されている為、削除できませんでした"
    end
    redirect_to employees_settings_departments_path
  end

  private
  
    def set_department
      @department = Department.find(params[:id])
    end
    
    def department_params
      params.require(:department).permit(:name)
    end
end
