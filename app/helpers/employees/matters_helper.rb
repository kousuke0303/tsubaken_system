module Employees::MattersHelper
    
  def matter_day(day)
    if day.present?
      day.strftime('%Y年%m月%d日')
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
  
  def status_disp(status)
    if status == "not_started"
      content_tag(:span, "未着工", class: "badge badge-danger")
    elsif status == "progress"
      content_tag(:span, "着工中", class: "badge badge-info")
    elsif status == "completed"
      content_tag(:span, "完了", class: "badge badge-success")
    end
  end
  
end
