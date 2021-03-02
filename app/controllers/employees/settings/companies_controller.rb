class Employees::Settings::CompaniesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!
  before_action :set_publishers, only: :index
  before_action :set_departments, only: :index
  before_action :set_attract_methods, only: :index
  
  def index
  end
end
