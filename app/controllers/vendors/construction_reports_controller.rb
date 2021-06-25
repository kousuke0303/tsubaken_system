class Vendors::ConstructionReportsController < ApplicationController
  before_action :set_construction_schedule
  before_action :set_construction_report, except: [:create, :register_start_time, :register_postponement]

  def create
    if @construction_schedule.construction_reports.create(create_params.merge(work_date: Date.current))
      redirect_to top_vendor_managers_path
    end
  end

  def register_start_time
    @construction_report = @construction_schedule.construction_reports.new(work_date: Date.current, start_time: Time.now)
    if @construction_report.save
      @responce = "success"
      construction_schedules_for_today
    end
  end

  def register_end_time
    if @construction_report.update(end_time: Time.now)
      @responce = "success"
      construction_schedules_for_today
    end
  end

  def report
    @reports_hash = ConstructionReport.reports.deep_dup
    @reports_hash.delete("not_set")
  end

  def register_postponement
    @construction_report = @construction_schedule.construction_reports.new
    @reasons_hash = ConstructionReport.reasons.deep_dup
    @reasons_hash.delete("no_select")
  end

  def show
  end

  def update
    if params[:construction_report][:report].present?
      params[:construction_report][:report] = params[:construction_report][:report].to_i
    end
    if @construction_report.update(update_params)
      flash[:success] = "本日もお疲れ様でした。"
      if current_vendor_manager
        redirect_to top_vendor_managers_url
      elsif current_external_staff
        redirect_to external_staffs_top_url
      end
    end
  end

  private
    def set_construction_schedule
      @construction_schedule = ConstructionSchedule.find(params[:construction_schedule_id])
    end

    def set_construction_report
      @construction_report = ConstructionReport.find(params[:id])
    end

    def create_params
      params.require(:construction_report).permit(:reason)
    end

    def update_params
      params.require(:construction_report).permit(:report, :memo)
    end
end
