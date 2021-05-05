# frozen_string_literal: true

module ConstructionScheduleDecorator
  
  def supplier_disp(supplier)
    if supplier.present?
      supplier.name
    else
      "未設定"
    end
  end
  
  def content_disp
    if self.content.present?
      content
    else
      "未設定"
    end
  end
  
  def scheduled_started_on_disp
    if self.scheduled_started_on
      self.scheduled_started_on.strftime("%-m月%-d日")
    else
      "未設定"
    end
  end
  
  def scheduled_finished_on_disp
    if self.scheduled_finished_on
      self.scheduled_finished_on.strftime("%-m月%-d日")
    else
      "未設定"
    end
  end
  
  def started_on_disp
    if self.started_on
      self.started_on.strftime("%-m月%-d日")
    end
  end
  
  def finished_on_disp
    if self.finished_on
      self.finished_on.strftime("%-m月%-d日")
    end
  end
  
  def started_on_display_for_external_staff(external_staff)
    if self.started_on.present?
      self.started_on.strftime("%-m月%-d日")
    elsif self.construction_schedule_of_current_external_staff?(external_staff)
      content_tag(:button, class: "btn btn-success", id: "started_on_for_#{self.id}") do
        concat '着工開始'
      end
    else
      "未設定"
    end
  end
  
  def finished_on_display_for_external_staff(external_staff)
    if self.finished_on.present? 
      self.finished_on.strftime("%-m月%-d日")
    elsif self.construction_schedule_of_current_external_staff?(external_staff) && self.started_on.present?
      content_tag(:button, class: "btn btn-danger", id: "finished_on_for_#{self.id}") do
        concat '完了'
      end
    else
      "未設定"
    end
  end
  
  def construction_schedule_of_current_external_staff?(external_staff)
    if self.supplier_id.present? && self.supplier_id == external_staff.supplier_id
      true
    else
      false
    end
  end
  
  def status_of_public
    if self.disclose
      content_tag(:span, "公開", class: "badge badge-danger")
    end
  end
  
  def budge
    if self.status == "completed"
      content_tag(:span, "#{self.title}", class: "badge badge-success")
    elsif self.status == "progress"
      content_tag(:span, "#{self.title}", class: "badge badge-danger")
    else
      content_tag(:span, "#{self.title}", class: "badge badge-secondary")
    end
  end
  
  def status_disp
    if self.status == "completed"
      content_tag(:span, "完了")
    elsif self.status == "progress"
      content_tag(:span, "着工中", class: "text-danger font-bold")
    end
  end
  
end
