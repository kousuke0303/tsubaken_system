class Employees::Settings::ReportsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_report, only: [:edit, :update, :destroy]

  def new
    @report = Report.new
  end

  def create
    @report = Report.new(report_params.merge(default: true))
    if @report.save
      flash[:success] = "報告書を作成しました。"
      redirect_to employees_settings_reports_url
    end
  end

  def edit
  end

  def update
    if @report.update(report_params)
      flash[:success] = "報告書を更新しました。"
      redirect_to employees_settings_reports_url
    end
  end

  def index
    @reports = Report.where(default: true)
  end

  def destroy
    @report.destroy ? flash[:success] = "報告書を削除しました。" : flash[:alert] = "報告書を削除できませんでした。"
    redirect_to employees_settings_reports_url
  end

  private
    def report_params
      params.require(:report).permit(:title)
    end

    def set_report
      @report = Report.find(params[:id])
    end
end
