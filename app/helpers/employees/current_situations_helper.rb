module Employees::CurrentSituationsHelper
  # ganttchart
  def ganttchart(matter)
    # matterの登録状況で場合分
    if matter.started_on.present? && matter.finished_on.present?
      @matter_work_day_arrey = [*matter.started_on..matter.finished_on]
      @gantt_type = "complete"
    elsif matter.started_on.present? && matter.finished_on.nil?
      @matter_work_day_arrey =[*matter.started_on..matter.scheduled_finished_on]
      @gantt_type = "progress"
    elsif matter.scheduled_started_on.present? && matter.scheduled_finished_on.present?
      @matter_work_day_arrey = [*matter.scheduled_started_on..matter.scheduled_finished_on]
      @gantt_type = "scheduled"
    else
      return false
    end
  end
end
