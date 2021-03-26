class Employees::Matters::ReportsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id

  def new
    @report = @matter.reports.new
    @image = Image.find(params[:image_id])
  end

  def create
    @report = @matter.reports.new(report_params)
    @report.save ? @responce = "success" : @responce = "false"
    set_reports_of_matter
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:title, :image_id)
    end
end
