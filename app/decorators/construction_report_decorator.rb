# frozen_string_literal: true

module ConstructionReportDecorator

  def start_time_disp
    self.start_time.strftime("%-H時%-M分")
  end

  def end_time_disp
    self.end_time.strftime("%-H時%-M分")
  end

  def work_date_disp
    self.work_date.strftime("%-y年%-m月%-d日")
  end

  def matter_title
    self.construction_schedule.matter.title
  end

  def memo_disp
    if self.memo.present?
      content_tag(:a, href: vendors_construction_schedule_construction_report_path(self.construction_schedule, self),
      class: "btn btn-dark", data: {remote: true} ) do
        concat "詳細"
      end
    else
      "未設定"
    end
  end

  def report_notification_for_me
    self.notifications.find_by(reciever_id: login_user.member_code.id)
  end


end
