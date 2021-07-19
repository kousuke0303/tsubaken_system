class Employees::Settings::OthersController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_label_colors

  def index
    @instructions = Instruction.where(default: true)
  end
end
