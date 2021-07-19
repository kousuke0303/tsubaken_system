# frozen_string_literal: true

module MatterDecorator
  
  def started_on_display
    if self.started_on.present?
      self.started_on.strftime("%Y年%-m月%-d日")
    end
  end
  
  def finished_on_display
    if self.finished_on.present?
      self.finished_on.strftime("%Y年%-m月%-d日")
    end
  end
  
  def scheduled_started_on_display
    if self.scheduled_started_on.present?
      self.scheduled_started_on.strftime("%Y年%-m月%-d日")
    end
  end
  
  def scheduled_finished_on_display
    if self.scheduled_finished_on.present?
      self.scheduled_finished_on.strftime("%Y年%-m月%-d日")
    end
  end
  
end
