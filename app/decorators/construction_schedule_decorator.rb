# frozen_string_literal: true

module ConstructionScheduleDecorator
  
  def person_in_charge
    if self.member_name
      return self.member_name
    else 
      MemberCode.find(self.member_code_id).parent.name
    end
  end
  
  def supplier_disp(supplier)
    if supplier.present?
      supplier.name
    else
      "未設定"
    end
  end
  
  def supplier_status(supplier)
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
    else
      content_tag(:p, "未着手", class: "text-danger")
    end
  end
  
  def finished_on_disp
    if self.finished_on
      self.finished_on.strftime("%-m月%-d日")
    elsif self.started_on.present?
      content_tag(:p, "未完了", class: "text-danger")
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
  
  def today_status
    if today_schedule = self.construction_reports.find_by(work_date: Date.today)
      if today_schedule.reason != "no_select"
        content_tag(:h5) do
          content_tag(:span, "本日作業休工", class: "badge badge-danger")
        end
      elsif today_schedule.report != "no_set"
        content_tag(:h5) do
          content_tag(:span, "報告あり", class: "badge badge-info")
        end
      elsif today_schedule.end_time.present?
        content_tag(:h5) do
          content_tag(:span, "本日作業終了", class: "badge badge-success")
        end
      elsif today_schedule.start_time.present?
        content_tag(:h5) do
          content_tag(:span, "本日作業中", class: "badge badge-primary")
        end
      else
        content_tag(:h5) do
          content_tag(:span, "本日未施工", class: "badge badge-warning")
        end
      end
    else
      content_tag(:h5) do
        content_tag(:span, "本日未施工", class: "badge badge-warning")
      end
    end
  end
  
  def title_disp
    if current_supplier_manager
      content_tag(:a, href: supplier_managers_matter_path(self.matter)) do
        concat self.matter.title
      end
    else
      content_tag(:a, href: employees_matter_path(self.matter)) do
        concat self.matter.title
      end
    end
  end
  
end
