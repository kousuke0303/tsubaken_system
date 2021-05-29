# frozen_string_literal: true

module ScheduleDecorator
  
  def scheduled_start_time_display
    self.scheduled_start_time.strftime('%H:%M')
  end
  
  def scheduled_end_time_display
    self.scheduled_end_time.strftime('%H:%M')
  end
end
