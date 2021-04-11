module EmployeesHelper
  
  # 編集権限があるかどうか(1対多) ※estimate_matter
  def update_authority?(object)
    if current_admin || current_manager
      true
    elsif current_staff
      object.staffs.find(current_staff.id).present? ? true : false
    elsif current_external_staff
      object.external_staffs.find(current_external_staff.id).present? ? true : false
    end
  end
  
  # 編集権限があるかどうか(1対1) ※schedule
  def update_authority_for_one?(object)
    if current_admin || current_manager
      true
    elsif current_staff
      object.staff_id == current_staff.id ? true : false
    elsif current_external_staff
      object.external_staff_id == current_external_staff.id ? true : false
    end
  end
  
  # 担当者の名前表示
  def member_name(schedule_or_sales_status)
    schedule_or_sales_status.member_name.present? ? schedule_or_sales_status.member_name : "登録なし"
  end
  
  # STAFF_COLOR
  def staff_color(staff_id)    
    Staff.find(staff_id).label_color.color_code if staff_id.present?
  end
  
  #PUBLISHER_NAME
  def publisher_name(id)
    id.present? ? Publisher.find(id).name : false
  end
  
  def home_icon(color, text)
    content_tag(:div, class: "home_icon") do
      concat(content_tag(:div, "", class: "triangle", style: "border-bottom-color: #{ color }"))
      concat(content_tag(:div, class: "square", style: "background: #{ color }") do
        concat(content_tag(:div, class: "window") do
          concat(content_tag(:div) do
            concat(content_tag(:p, "■■"))
            concat(content_tag(:p, "■■"))
          end)
        end)
        concat(content_tag(:div, "#{ text }", class: "text"))
      end)
    end    
  end
  
  # アカウント利用停止ボタン
  def out_of_service(user)
    if user.avaliable == false
      content_tag(:div, class: "text-right") do
        content_tag(:h3) do
          content_tag(:span, "アカウント利用停止中", class: "badge badge-danger")
        end
      end
    end
  end
end