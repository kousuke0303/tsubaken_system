class Employees::Settings::DepartmentsController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :set_department, only: [:update, :destroy]
  
  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "部署を作成しました"
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
      flash[:success] = "部署情報を更新しました"
      redirect_to employees_settings_departments_url
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    # 無所属は削除できないように設定
    if @department.id == 1
      flash[:alert] = "無所属は削除できません"
      exit
    end
    @manager_dept_ids = Manager.pluck(:department_id)
    @staff_dept_ids = Staff.pluck(:department_id)
    # 部署削除時、その部署に所属のマネージャーを無所属にupdate
    if @manager_dept_ids.any?{|i| i == @department.id}
      Manager.where('department_id = ?', @department.id).update_all(:department_id => 1)
    end
    # 部署削除時、その部署に所属のスタッフを無所属にupdate
    if @staff_dept_ids.any?{|i| i == @department.id}
      Staff.where('department_id = ?', @department.id).update_all(:department_id => 1)
    end
    @department.destroy ? flash[:success] = "部署を削除しました" : flash[:alert] = "部署を削除できませんでした"
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
