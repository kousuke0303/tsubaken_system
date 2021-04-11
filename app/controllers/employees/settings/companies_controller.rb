class Employees::Settings::CompaniesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_publishers
  before_action :set_departments
  before_action :set_attract_methods
  before_action :set_industries
  
  def index
    @department = Department.new
    @attract_method = AttractMethod.new
    @industry = Industry.new
  end
end
