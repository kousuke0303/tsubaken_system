class Employees::Settings::Companies::DepartmentsController < Employees::Settings::CompaniesController
  before_action :set_department, only: [:edit, :update, :destroy]
  
  def new
    @department = Department.new
  end

  def create
    @department = Department.new(department_params)
    @department.save ? @responce = "success" : @responce = "failure"
    set_departments
  end

  def edit
  end

  def update
    @department.update(department_params) ? @responce = "success" : @responce = "failure"      
    set_departments
  end

  def destroy
    if @department.id != 1
      @department.managers.update_all(department_id: 1)
      @department.staffs.update_all(department_id: 1)
      @department.delete
      @responce = "success"
    else
      @responce = "failure"
    end
    set_departments
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
