class Employees::InquiriesController < Employees::EmployeesController
  before_action :authenticate_admin_or_manager!

  def index
    @inquiries = Inquiry.all
  end
end
