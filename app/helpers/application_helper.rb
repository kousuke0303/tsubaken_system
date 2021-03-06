require 'employees_helper.rb'

module ApplicationHelper
  include EmployeesHelper
  include VendorsHelper

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

  def own_staff?
    if current_admin || current_manager || current_staff
      true
    else
      false
    end
  end

  # ---------------------------------------------------------
      # AVATOR
  # ---------------------------------------------------------

  def edit_avator(login_user)
    if login_user.avator.attached?
      content_tag(:div, class: "avator_layout_for_edit", id: "avator-image") do
        image_tag url_for(login_user.avator.variant(combine_options:{gravity: :center, resize:"150x150^",crop:"150x150+0+0"}))
      end
    else
      if @admin
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layout_for_edit", style: "background: #dc3545")
      elsif @manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layout_for_edit", style: "background: #a486d4")
      elsif @staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layout_for_edit", style: "background: #{@staff.label_color.color_code}")
      elsif @vendor_manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layout_for_edit", style: "background: #17a2b8")
      elsif @external_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layout_for_edit", style: "background: #e4c35e")
      end
    end
  end

  def sidebar_avator(login_user)
    if login_user.avator.attached?
      content_tag(:div, class: "mini_avator_layout_container") do
        image_tag url_for(login_user.avator.variant(combine_options:{gravity: :center, resize:"50x50^",crop:"50x50+0+0"}))
      end
    else
      if current_admin
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #dc3545")
      elsif current_manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #a486d4")
      elsif current_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #{current_staff.label_color.color_code}")
      elsif current_vendor_manager
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #17a2b8")
      elsif current_external_staff
        content_tag(:div, login_user.name[0, 1], class: "default_avator_layoput_for_sidebar", style: "background: #e4c35e")
      end
    end
  end

  def show_avator(object)
    if object.avator.attached?
      content_tag(:div, class: "mini_avator_layout_container") do
        image_tag url_for(login_user.avator.variant(combine_options:{gravity: :center, resize:"50x50^",crop:"50x50+0+0"}))
      end
    else
      if object == @admin
        content_tag(:div, @admin.name[0, 1], class: "default_avator_layout_for_show", style: "background: #dc3545")
      elsif object == @manager
        content_tag(:div, @manager.name[0, 1], class: "default_avator_layout_for_show", style: "background: #a486d4")
      elsif object == @staff
        content_tag(:div, @staff.name[0, 1], class: "default_avator_layout_for_show", style: "background: #{@staff.label_color.color_code}")
      elsif object == @external_staff
        content_tag(:div, @external_staff.name[0, 1], class: "default_avator_layout_for_show", style: "background: #e4c35e")
      end
    end
  end

  def task_avator(target_person)
    if target_person.avator.attached?
      content_tag(:div, class: "mini_avator_layout_container") do
        image_tag url_for(target_person.avator.variant(combine_options:{gravity: :center, resize:"40x40^",crop:"40x40+0+0"}))
      end
    else
      if target_person.auth == "admin"
        content_tag(:div, target_person.name[0, 1], class: "default_avator_layout_for_task", style: "background: #dc3545")
      elsif target_person.auth == "manager"
        content_tag(:div, target_person.name[0, 1], class: "default_avator_layout_for_task", style: "background: #a486d4")
      elsif target_person.auth == "staff"
        content_tag(:div, target_person.name[0, 1], class: "default_avator_layout_for_task", style: "background: #{target_person.label_color.color_code}")
      elsif target_person.auth == "external_staff"
        content_tag(:div, target_person.name[0, 1], class: "default_avator_layout_for_task", style: "background: #e4c35e")
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

  def member_name_from_member_code(member_code)
    member_code.member_name_from_member_code
  end

  def member_name_from_member_code_id(code_id)
    membercode = MemberCode.find(code_id)
    membercode.parent.name
  end

  def postal_code_display(post_code)
    block_1 = post_code[0..2]
    block_2 = post_code[3..6]
    return "〒" + block_1 + "-" + block_2
  end

  def phone_formatted(phone_number)
    if phone_number.present?
      phone = Phonelib.parse("#{phone_number}", :jp)
      if phone.valid?
        content_tag(:a, href: 'tel:#{phone_number}') do
          phone.national
        end
      else
        "日本の電話番号ではありません。"
      end
    else
      "未設定"
    end
  end

  # cut/context
  def content_display(content, limit)
    if content.size > limit
      content[0, limit] + "......"
    else
      content
    end
  end
  
  def avaliable_disp(user)
    if user.avaliable
      content_tag(:div, "") do
        concat content_tag(:span, "利用可", class: "badge badge-success")
      end
    else
      content_tag(:div, "") do
        concat content_tag(:span, "ログイン不可", class: "badge badge-danger")
      end
    end
  end
  
  # ---------------------------------------------------------
      # ENUM_SELECT
  # ---------------------------------------------------------
  
  # クラスオブジェクトとカラム名を引数として呼ばれるコールバック関数です
  def options_for_select_from_enum(klass,column)
    #該当クラスのEnum型リストをハッシュで取得
    enum_list = klass.send(column.to_s.pluralize)
    #Enum型のハッシュリストに対して、nameと日本語化文字列の配列を取得（valueは使わないため_)
    enum_list.map do | name , _value |
      # selectで使うための組み合わせ順は[ 表示値, value値 ]のため以下の通り設定
      [ t("enums.#{klass.to_s.downcase}.#{column}.#{name}") , name ]
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
    attendance.worked_on != Date.current && attendance.started_at.present? && attendance.finished_at == nil
  end

  def own_finished_at_nil_notification(object_user)
    yesterday = Date.current - 1
    attendance = object_user.attendances.find_by(worked_on: yesterday)
    if attendance && attendance.started_at.present? && attendance.finished_at == nil
      "昨日の退勤処理がありません。管理者に報告してください！"
    end
  end

  # ---------------------------------------------------------
      # Alert_Lists
  # ---------------------------------------------------------

  def member_code(id)
    MemberCode.find(id)
  end

  def ja_auth(auth)
    case auth
    when "admin"
      "管理者"
    when "manager"
      "マネージャー"
    when "staff"
      "スタッフ"
    when "external_staff"
      "外部スタッフ"
    end
  end

  def alert_task_title(alert_tasks)
    alert_tasks.keys.map{|id| Task.title_from_id(id)}.join('/')

  end

  # ---------------------------------------------------------
      # TASK
  # ---------------------------------------------------------

  def task_remarks(task, title)
    if task.matter_id.present?
      @relation_title = title
      @type = "着工案件"
      @path = "employees_matter_path"
      @path_id = task.matter_id
    elsif task.estimate_matter_id
      @relation_title = title
      @type = "見積案件"
      @path = "employees_estimate_matter_path"
      @path_id = task.estimate_matter_id
    end
  end

end
