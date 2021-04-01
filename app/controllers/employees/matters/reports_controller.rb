class Employees::Matters::ReportsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_matter_by_matter_id
  before_action :set_report, only: [:edit, :update, :destroy]
  before_action :preview_display, only: :index

  def index
    if @report_cover = @matter.report_cover
      set_images_of_report_cover
      publisher = @report_cover.publisher
      @company_address = "#{ publisher.prefecture_code }#{ publisher.address_city }#{ publisher.address_street }"
    end
    @reports = @matter.reports
    @address = "#{ @matter.prefecture_code }#{ @matter.address_city }#{ @matter.address_street }"
  end

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
    @image = @report.image
  end

  def update
    @report.update(report_params) ? @responce = "success" : @responce = "false"
    set_reports_of_matter
  end

  def destroy
    @report.destroy ? @responce = "success" : @responce = "false"
    set_reports_of_matter
  end

  def sort
    from = params[:from].to_i + 1
    report = @matter.reports.find_by(position: from)
    report.insert_at(params[:to].to_i + 1)
    set_reports_of_matter
  end

  private
    def set_report
      @report = Report.find(params[:id])
    end

    def report_params
      params.require(:report).permit(:title, :image_id)
    end
end
