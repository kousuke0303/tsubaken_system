require 'employees_helper.rb'

module ApplicationHelper
  include EmployeesHelper
  
  def admin_name(id)
    Admin.find(id).name
  end
  
  def manager_name(id)
    Manager.find(id).name
  end
  
  def staff_name(id)
    Staff.find(id).name
  end
  
  def external_staff_name(id)
    ExternalStaff.find(id).name
  end
  
  # ---------------------------------------------------------
      # AVATOR
  # ---------------------------------------------------------
  
  def edit_avator(login_user)
    if login_user.avator.attached? 
      content_tag(:div, class: "avator_layoput_for_edit") do
        image_tag url_for(login_user.avator.variant(combine_options:{gravity: :center, resize:"150x150^",crop:"150x150+0+0"}))
      end
    else
      if current_admin
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_edit", style: "background: #dc3545")
      elsif current_manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_edit", style: "background: #6610f2") 
      elsif current_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_edit", style: "background: #{current_staff.label_color.color_code}")
      elsif current_external_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_edit", style: "background: #28a745")
      end
    end
  end
  
  def sidebar_avator(login_user)
    if login_user.avator.attached? 
      content_tag(:div, class: "avator_layoput_for_sidebar") do
        image_tag url_for(login_user.avator.variant(combine_options:{gravity: :center, resize:"50x50^",crop:"50x50+0+0"}))
      end
    else
      if current_admin
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #dc3545")
      elsif current_manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #6610f2")
      elsif current_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #{current_staff.label_color.color_code}")
      elsif current_external_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #28a745")
      end
    end
  end


  # 空のtdタグを引数分返す
  def empty_td(num)
    td = content_tag(:td)
    tags = td
    (num - 1).times do |time|
      tags += td
    end
    tags
  end
  
  # ---------------------------------------------------------
      # COMMON DISPLAY
  # ---------------------------------------------------------
  
  def postal_code_display(post_code)
    block_1 = post_code[0..2]
    block_2 = post_code[3..6]
    return "〒" + block_1 + "-" + block_2
  end
  
  def mobile_phone_display(phone_number)
    if phone_number.size == 11
      block_1 = phone_number[0..2]
      block_2 = phone_number[3..6]
      block_3 = phone_number[7..10]
      return block_1 + "-" + block_2 + "-" + block_3
    else
      return phone_number
    end
  end
  # ---------------------------------------------------------
      # ATTENDANCE
  # ---------------------------------------------------------
  
  def working_calculation(attendance)
    if attendance.finished_at.present?
      day_working_calc = (attendance.finished_at - attendance.started_at) / 3600
      disp_day_working_calc = day_working_calc.floor(2) 
      return sprintf("%.2f", disp_day_working_calc)
    end
  end
  
  def finished_nil?(attendance)
    if attendance.worked_on != Date.current && attendance.started_at.present? && attendance.finished_at == nil
      return true
    end
  end
  
  def own_finished_at_nil_notification(object_user)
    yesterday = Date.current - 1
    attendance = object_user.attendances.find_by(worked_on: yesterday)
    if attendance.started_at.present? && attendance.finished_at == nil
      return "昨日の退勤処理がありません。管理者に報告してください！"
    end
  end
  
  def object_user_name(attendance)
    if attendance.manager_id.present?
      return Manager.find(attendance.manager.id).name
    elsif attendance.staff_id.present?
      return Staff.find(attendance.staff_id).name
    elsif attendance.external_staff_id.present?
      return ExternalStaff.find(attendance.external_staff_id).name
    end
  end
  
end
