class DepartmentsController < ApplicationController
  befrore_action :authenticate_admin_or_manager!
  
  def new
    @department = Department.new
  end
  
  def create
  end

  def show
  end

  def index
    @departments = Department.all
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def department_params
      params.require(:department).permit(:name)
    end
end
