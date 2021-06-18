module SuppliersHelper
  
  def construction_report_status(construction_schedule)
    construction_report = construction_schedule.construction_reports.find_by(work_date: Date.current)
    unless construction_report.nil?
      if construction_report.report != "not_set" || construction_report.reason != "no_select"
        @status = "complete"
      elsif construction_report.end_time.present?
        @status = "report"
      elsif construction_report.start_time.present?
        @status = "finish"
      end
    else
      @status ="start"
    end
  end

  def start_of_construction_btn(construction_schedule)
    construction_report_status(construction_schedule)
    case @status
    when "start"
      content_tag(:a, class: "btn btn-success", href: register_start_time_suppliers_construction_schedule_construction_reports_path(construction_schedule), data: {remote: "true"}) do
        concat "本日の作業開始"
      end
    when "finish"
      construction_report = construction_schedule.construction_reports.find_by(work_date: Date.current)
      content_tag(:a, class: "btn btn-danger", href: register_end_time_suppliers_construction_schedule_construction_report_path(construction_schedule, construction_report), data: {remote: "true"}) do
        concat "本日の作業終了"
      end
    when "report"
      construction_report = construction_schedule.construction_reports.find_by(work_date: Date.current)
      content_tag(:a, class: "btn btn-danger", href: report_suppliers_construction_schedule_construction_report_path(construction_schedule, construction_report), data: {remote: "true"}) do
        concat "報告"
      end
    when "complete"
      content_tag(:h5) do
        content_tag(:span, "報告完了", class: "badge badge-success")
      end
    end
  end
  
  def postponement_of_work(construction_schedule)
    construction_report_status(construction_schedule)
    if @status == "start"
      content_tag(:a, class: "btn btn-danger mt-10", href: register_postponement_suppliers_construction_schedule_construction_reports_path(construction_schedule), data: {remote: "true"}) do
        concat "本日の作業延期"
      end
    end
  end
  
end