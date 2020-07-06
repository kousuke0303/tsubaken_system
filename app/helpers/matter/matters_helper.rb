module Matter::MattersHelper
  
  def matter_day(day)
    day.strftime('%Y年%m月%d日')
  end
  
  def manage_authority_badge(submanager)
    if submanager.matter_submanagers.find_by(matter_id: current_matter.id).manage_authority == true
      content_tag :span, "窓口担当", class: "badge badge-pill badge-info ml-1e"
    end
  end

  def automatic_event_creation(matter)
    if matter.scheduled_start_at.present?
      Event.create!(event_name: "着工予定日",
        event_type: "D",
        date: matter.scheduled_start_at,
        note: "",
        manager_id: dependent_manager.id,
        matter_id: matter.id
      )
    end
    if matter.scheduled_finish_at.present?
      Event.create!(event_name: "完了予定日",
        event_type: "D",
        date: matter.scheduled_finish_at,
        note: "",
        manager_id: dependent_manager.id,
        matter_id: matter.id
      )
    end
  end

  def automatic_event_update(matter)
    event_scheduled_start_at = 
        Event.find_by(event_name: "着工予定日",
        event_type: "D",
        manager_id: dependent_manager.id,
        matter_id: matter.id)
    if matter.scheduled_start_at.present?
      if event_scheduled_start_at.present?
        event_scheduled_start_at.update(date: matter.scheduled_start_at)
      else
          Event.create!(event_name: "着工予定日",
            event_type: "D",
            date: matter.scheduled_start_at,
            note: "",
            manager_id: dependent_manager.id,
            matter_id: matter.id
          )
      end
    else
      if event_scheduled_start_at.present?
        event_scheduled_start_at.destroy
      end
    end

    event_scheduled_finish_at = 
        Event.find_by(event_name: "完了予定日",
        event_type: "D",
        manager_id: dependent_manager.id,
        matter_id: matter.id)
    if matter.scheduled_finish_at.present?
      if event_scheduled_finish_at.present?
        event_scheduled_finish_at.update(date: matter.scheduled_finish_at)
      else
        Event.create!(event_name: "完了予定日",
          event_type: "D",
          date: matter.scheduled_finish_at,
          note: "",
          manager_id: dependent_manager.id,
          matter_id: matter.id
        )
      end
    else
      if event_scheduled_finish_at.present?
        event_scheduled_finish_at.destroy
      end
    end
  end
  
  # ganttchart
  def ganttchart(matter)
    # matterの登録状況で場合分
    if matter.started_at.present? && matter.finished_at.present?
      @matter_work_day_arrey = [*matter.started_at..matter.finished_at]
      @gantt_type = "complete"
    elsif matter.started_at.present? && matter.finished_at.nil?
      @matter_work_day_arrey =[*matter.started_at..matter.scheduled_finish_at]
      @gantt_type = "progress"
    elsif matter.scheduled_start_at.present? && matter.scheduled_finish_at.present?
      @matter_work_day_arrey = [*matter.scheduled_start_at..matter.scheduled_finish_at]
      @gantt_type = "scheduled"
    else
      return false
    end
  end
  
  def month_matters(first_day, last_day)
    dependent_manager.matters.where(started_at: first_day..last_day)
    .or(dependent_manager.matters.where(finished_at: first_day..last_day))
    .or(dependent_manager.matters.where(scheduled_start_at: first_day..last_day))
    .or(dependent_manager.matters.where(scheduled_finish_at: first_day..last_day))
  end
end
