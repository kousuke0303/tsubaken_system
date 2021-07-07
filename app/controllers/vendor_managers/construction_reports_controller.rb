class VendorManagers::ConstructionReportsController < ApplicationController
  before_action :authenticate_vendor_manager!

  def index
    if params[:type] == "uncheck"
      @type = "uncheck"
      notification_ids = login_user.recieve_notifications.creation_notification_for_report.ids
      @uncheck_reports = ConstructionReport.joins(:notifications).where(notifications: {id: notification_ids})
      @uncheck_for_run = @uncheck_reports.includes(:notifications).where.not(report: 0)
      @uncheck_for_postponement = @uncheck_reports.includes(:notifications).where.not(reason: 0)
    elsif params[:type] == "no_report"
      @type = "no_report"
      @construction_schedule = ConstructionSchedule.includes(:construction_reports).find(params[:construction_schedule_id])
    elsif params[:type] == "date"
      construction_reports = ConstructionReport.includes(construction_schedule: :matter)
                                               .where(work_date: params[:work_date])
                                               .where(construction_schedules: {vendor_id: login_user.vender.id})
      @reports_for_run = construction_reports.where.not(report: 0)
      @reports_for_postponement = construction_reports.where.not(reason: 0)
    end
  end

  def confirmation
    @construction_reports = ConstructionReport.where(id: params[:report_ids])
    @construction_reports.update_all(sm_check: true)
    @notifications = login_user.recieve_notifications.where(construction_report_id: @construction_reports.ids)
    @notifications.update(status: 1)
    redirect_to top_vendor_managers_path
  end

  def edit
    @construction_report = ConstructionReport.find(params[:id])
    @construction_schedule = @construction_report.construction_schedule
    @reports_hash = ConstructionReport.reports.deep_dup
    @reports_hash.delete("not_set")
  end

  def update
    @construction_report = ConstructionReport.find(params[:id])
    @construction_schedule = @construction_report.construction_schedule
    if params[:construction_report][:report].present?
      params[:construction_report][:report] = ConstructionReport.reports.keys[params[:construction_report][:report].to_i]
    end
    # notification用変数
    @construction_report.sender = login_user.member_code.id
    if @construction_report.update(update_params.merge(sm_check: false, admin_check: false))
      flash[:success] = "#{ @construction_schedule.title }の報告書を編集しました"
      redirect_to vendor_managers_construction_reports_path
    end
  end

  private
    def update_params
      params.require(:construction_report).permit(:start_time, :end_time, :report, :memo)
    end
end
