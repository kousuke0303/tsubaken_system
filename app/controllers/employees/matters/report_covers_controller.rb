class Employees::Matters::ReportCoversController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id
  before_action :set_report_cover, only: [:edit, :update, :destroy]

  def new
    @report_cover = @matter.build_report_cover
    @images = @matter.images
  end

  def create
    @report_cover = @matter.reports.new(report_cover_params)
    @report_cover.save ? @responce = "success" : @responce = "false"
  end

  def edit
    @images = @matter.images
  end

  def update
  end

  private
  def set_report_cover
    @report = Report.find(params[:id])
  end

  def report_cover_params
    params.require(:report_cover).permit(:title, :publisher_id, :img_1_id, :img_2_id, :img_3_id, :img_4_id)
  end
end
