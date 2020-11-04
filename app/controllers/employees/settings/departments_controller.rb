class Employees::Settings::DepartmentsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_department, only: [:update, :destroy]
  
  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "部署を作成しました。"
      redirect_to employees_settings_departments_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def index
    @department = Department.new
    @departments = Department.all
    # @departments = Department.where.not(id: 1)
  end

  def update
    if @department.update(department_params)
      flash[:success] = "部署情報を更新しました。"
      redirect_to employees_settings_departments_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    if @department.id != 1
      @department.managers.update_all(department_id: 1)
      @department.staffs.update_all(department_id: 1)
      @department.delete
      flash[:success] = "部署を削除しました。"
    else
      flash[:notice] = "部署を削除できませんでした。"
    end
    redirect_to employees_settings_departments_url
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end
    
    def department_params
      params.require(:department).permit(:name)
    end
end
