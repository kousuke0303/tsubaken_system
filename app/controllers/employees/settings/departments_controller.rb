class Employees::Settings::DepartmentsController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_department, only: [:edit, :update, :destroy]
  before_action :set_departments, only: :index

  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    if @department.save
      flash[:success] = "部署を作成しました。"
      redirect_to employees_settings_departments_url
    end
  end

  def index
  end

  def edit
  end

  def update
    if @department.update(department_params)
      flash[:success] = "部署情報を更新しました。"
      redirect_to employees_settings_departments_url
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

  def sort
    from = params[:from].to_i + 1
    department = Department.find_by(position: from)
    department.insert_at(params[:to].to_i + 1)
    set_departments
  end

  private
    def set_department
      @department = Department.find(params[:id])
    end
    
    def department_params
      params.require(:department).permit(:name)
    end
end
