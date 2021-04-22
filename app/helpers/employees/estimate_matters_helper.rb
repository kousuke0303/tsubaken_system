module Employees::EstimateMattersHelper
  
  def sales_status_disp(status)
    content_tag(:span, "#{status}", class: "badge badge-info")
  end
  
  def client_avaliable_disp(client_avaliable)
    if client_avaliable
      content_tag(:span, "ログイン可能", class: "badge badge-primary ml-2e")
    else
      content_tag(:span, "ログイン未許可", class: "badge badge-dark ml-2e")
    end
  end
  
end