class AlertsController < ApplicationController
  
  
  def alert_task_index
    alert_tasks
  end
  
  def alert_report_index
    non_report_construction_schedule
  end
end
