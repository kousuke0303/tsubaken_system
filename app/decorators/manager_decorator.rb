module ManagerDecorator

  # adminのmanager認証ボタン
  def approved
    if approval
      content_tag(:a, "未承認にする", href: "#{non_approval_admin_manager_path(self)}", data: {confirm: "#{self.company}を未承認にしますか"}, class: 'btn btn-dark btn-sm')
    else
      a = content_tag :span do
            a_tag = content_tag(:button, "承認", id: "approved_#{self.id}", class: 'btn btn-sm btn-primary')
            concat(a_tag)
          end
      b = content_tag :span do
            b_tag = content_tag(:a, "削除", href: "#{admin_manager_path(self)}", data: {confirm: "削除しますか", method: :delete}, class: 'ml-1e btn btn-sm btn-danger')
            concat(b_tag)
          end
      return a + b
    end
  end
  
end
