module SupplierManagers::ConstructionSchedulesHelper
  
  def ganttchart_for_constrcution(schedule)
    # scheduleの登録状況で場合分
    if schedule.started_on.present? && schedule.finished_on.present?
      @schedule_work_day_arrey = [*schedule.started_on..schedule.finished_on]
      @gantt_type = "complete"
    elsif schedule.started_on.present? && schedule.finished_on.nil?
      @schedule_work_day_arrey =[*schedule.started_on..schedule.scheduled_finished_on]
      @gantt_type = "progress"
    elsif schedule.scheduled_started_on.present? && schedule.scheduled_finished_on.present?
      @schedule_work_day_arrey = [*schedule.scheduled_started_on..schedule.scheduled_finished_on]
      @gantt_type = "scheduled"
    else
      return false
    end
  end
end
