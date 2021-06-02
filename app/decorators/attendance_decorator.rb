# frozen_string_literal: true

module AttendanceDecorator
  
  def target_user_name
    self.member_code.parent.name
  end
  
  def worked_on_disp
    self.worked_on.strftime('%-m月%-d日')
  end
end
