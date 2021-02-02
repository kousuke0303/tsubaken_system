class Employees::EstimateMatters::SalesStatusesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:show, :edit, :update, :destroy]
  before_action :set_statuses, only: [:new, :edit]
  before_action ->{ set_person_in_charge(@estimate_matter) }, only: [:new, :edit]
  before_action :estimate_matter_members, only: [:new, :edit]
  
  def new
    @sales_status = @estimate_matter.sales_statuses.new 
    @type = "new"
  end

  def create
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)
    
    # メンバーパラメーター整形
    member_parmater
    
    # スケジュールバリデーションが必要なケース
    if params[:sales_status][:schedule] == "1"
      schedule_validation
    end
    
    # 結果、バリデーションに引っかかったらエラーで返す
    if @result == "failure"
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)   
    ActiveRecord::Base.transaction do
      @sales_status.save
      member_in_charge
      save_editor
    end
      @response = "success"
      @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
      @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
      respond_to do |format|
        format.js
      end
    end
    
    # バリデーションセーフ又はスケジュールバリデーション不要な場合
    if @result != "failure" 
      ActiveRecord::Base.transaction do
        @sales_status.save!
        save_member
        save_editor
        if params[:sales_status][:schedule] == "1"   
          schedule_create
        end
        @response = "success"
        @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
        respond_to do |format|
          format.js
        end
      rescue
        @response = "false"
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def show
  end
  
  def edit
    if Schedule.find_by(sales_status_id: @sales_status.id).present?
      @type = "edit"
    else
      @type = "new"
    end
  end

  def update
    # 担当者パラメーター整形
    member_parmater
    
    # 状況場合分
    case params[:sales_status][:schedule]
    when "3"
      type = "schedule_destroy"
      @schedule = Schedule.find_by(sales_status_id: @sales_status.id)
    when "2"
      type = "schedule_update"
      @schedule = Schedule.find_by(sales_status_id: @sales_status.id)
    when "1"
      type = "schedule_create"
    end
      @response = "success"
      @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
      @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
    
    # スケジュールバリデーション
    if type == "schedule_destroy"
      @schedule.destroy
    elsif type == "schedule_create" 
      schedule_validation
    elsif type == "schedule_update"
      schedule_validation
    end
    
    # 結果、バリデーションに引っかかったらエラーで返す
    if @result == "failure"
      respond_to do |format|
        format.js
      end
    end
    
    # エラーがない場合
    if @result != "failure" 
      ActiveRecord::Base.transaction do
        @sales_status.update!(sales_status_params)
        save_member
        save_editor
        if type == "schedule_create"
          schedule_create
        elsif type == "schedule_update"
          schedule_update
        end
        @response = "success"
        @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
        respond_to do |format|
          format.js
        end
      rescue
        @response = "false"
        respond_to do |format|
          format.js
        end
      end
    end
  end

  def destroy
    @sales_status.destroy
    schedule = Schedule.find_by(sales_status_id: @sales_status.id)
    schedule.destroy
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
    respond_to do |format|
      format.js
    end
  end

  private
    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:status, :conducted_on, :scheduled_start_time, :scheduled_end_time, :place, :note, :staff_id, :external_staff_id)
    end

    def set_statuses
      @statuses = SalesStatus.statuses.except("not_set").keys.map{ |k| [I18n.t("enums.sales_status.status.#{ k }"), k] }
    end
    
    def estimate_matter_members
      @members = []
      Admin.all.each do |admin|
        @members << { auth: admin.auth, id: admin.id, name: admin.name }
      end
      Manager.all.each do |manager|
        @members << { auth: manager.auth, id: manager.id, name: manager.name }
      end
      @estimate_matter.staffs.each do |staff|
        @members << { auth: staff.auth, id: staff.id, name: staff.name }
      end
      @estimate_matter.external_staffs.each do |external_staff|
        @members << { auth: external_staff.auth, id: external_staff.id, name: external_staff.name }
      end
      return @members
    end
    
    def member_parmater
      params_editor = params[:sales_status][:member].split("#")
      @params_authority = params_editor[0]
      @params_member_id = params_editor[1].to_i
    end
    
    def save_member
      if params[:commit] == "作成"
        @sales_status.create_sales_status_member(authority: @params_authority, member_id: @params_member_id)
      elsif params[:commit] == "更新"
        @sales_status_member = @sales_status.sales_status_member
        @sales_status_member.update!(authority: @params_authority, member_id: @params_member_id)
      end
    end
    
    def save_editor
      if params[:commit] == "作成"
        if current_admin
          @sales_status.create_sales_status_editor(authority: current_admin.auth, member_id: current_admin.id)
        elsif current_manager
          @sales_status.create_sales_status_editor(authority: current_manager.auth, member_id: current_manager.id)
        elsif current_staff
          @sales_status.create_sales_status_editor(authority: current_staff.auth, member_id: current_staff.id)
        elsif current_external_staff
          @sales_status.create_sales_status_editor(authority: current_external_staff.auth, member_id: current_external_staff.id)
        end
      elsif params[:commit] == "更新"
        @sales_status_editor = @sales_status.sales_status_editor
        if current_admin
          @sales_status_editor.update!(authority: current_admin.auth, member_id: current_admin.id)
        elsif current_manager
          @sales_status_editor.update!(authority: current_manager.auth, member_id: current_manager.id)
        elsif current_staff
          @sales_status_editor.update!(authority: current_staff.auth, member_id: current_staff.id)
        elsif current_external_staff
          @sales_status_editor.update!(authority: current_external_staff.auth, member_id: current_external_staff.id)
        end
      end        
    end
    
    def schedule_validation
      object_start_time = Time.zone.parse("2000-01-01 #{params[:sales_status][:scheduled_start_time]}")
      object_end_time = Time.zone.parse("2000-01-01 #{params[:sales_status][:scheduled_end_time]}")
      case @params_authority
      when "admin"
        if params[:commit] == "更新"
          duplicate_schedule = Schedule.where.not(id: @schedule.id)
                                       .where(admin_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        else 
          duplicate_schedule = Schedule.where(admin_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        end
      when "manager"
        if params[:commit] == "更新"
          duplicate_schedule = Schedule.where.not(id: @schedule.id)
                                       .where(manager_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        else 
          duplicate_schedule = Schedule.where(manager_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        end
      when "staff"
        if params[:commit] == "更新"
          duplicate_schedule = Schedule.where.not(id: @schedule.id)
                                       .where(staff_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        else 
          duplicate_schedule = Schedule.where(staff_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        end
      when "external_staff"
        if params[:commit] == "更新"
          duplicate_schedule = Schedule.where.not(id: @schedule.id).where(external_staff_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        else 
          duplicate_schedule = Schedule.where(external_staff_id: @params_member_id, scheduled_date: params[:sales_status][:conducted_on])
                                       .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
        end
      end
      if duplicate_schedule.present?
        @sales_status.errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
        @result = "failure"
      end
      # presence validate
      if params[:sales_status][:conducted_on].empty?
        @sales_status.errors.add(:conducted_on, "：スケジュール登録には、予定日必須")
        @result = "failure"
      elsif params[:sales_status][:scheduled_start_time].empty?
        @sales_status.errors.add(:scheduled_start_time, "：スケジュール登録には、開始予定時刻必須")
        @result = "failure"
      elsif params[:sales_status][:scheduled_end_time].empty? 
        @sales_status.errors.add(:scheduled_end_time, "：スケジュール登録には、終了予定時刻必須")
        @result = "failure"
      elsif params[:sales_status][:scheduled_start_time] >= params[:sales_status][:scheduled_end_time]
        @sales_status.errors.add(:scheduled_end_time, "：終了予定時刻は開始予定時刻より後の時間を登録してください")
        @result = "failure"
      end
    end
    
    def schedule_create
      @schedule = Schedule.create!(title: @sales_status.status_i18n,
                               scheduled_date: @sales_status.conducted_on,
                               scheduled_start_time: @sales_status.scheduled_start_time,
                               scheduled_end_time: @sales_status.scheduled_end_time,
                               place: @sales_status.place,
                               note: @sales_status.note,
                               sales_status_id: @sales_status.id)
      case @params_authority
      when "admin"
        @schedule.update_attributes!(admin_id: @params_member_id)
      when "manager"
        @schedule.update_attributes!(manager_id: @params_member_id)
      when "staff"
        @schedule.update_attributes!(staff_id: @params_member_id)
      when "external_staff"
        @schedule.update_attributes!(external_staff_id: @params_member_id)
      end
    end
    
    def schedule_update
      case @params_authority
      when "admin"
        @schedule.update_attributes!(title: @sales_status.status_i18n,
                               scheduled_date: @sales_status.conducted_on,
                               scheduled_start_time: @sales_status.scheduled_start_time,
                               scheduled_end_time: @sales_status.scheduled_end_time,
                               place: @sales_status.place,
                               note: @sales_status.note,
                               admin_id: @params_member_id)
      when "manager"
        @schedule.update_attributes!(title: @sales_status.status_i18n,
                               scheduled_date: @sales_status.conducted_on,
                               scheduled_start_time: @sales_status.scheduled_start_time,
                               scheduled_end_time: @sales_status.scheduled_end_time,
                               place: @sales_status.place,
                               note: @sales_status.note,
                               managher_id: @params_member_id)
      when "staff"
        @schedule.update_attributes!(title: @sales_status.status_i18n,
                               scheduled_date: @sales_status.conducted_on,
                               scheduled_start_time: @sales_status.scheduled_start_time,
                               scheduled_end_time: @sales_status.scheduled_end_time,
                               place: @sales_status.place,
                               note: @sales_status.note,
                               staff_id: @params_member_id)
      when "external_staff"
        @schedule.update_attributes!(title: @sales_status.status_i18n,
                               scheduled_date: @sales_status.conducted_on,
                               scheduled_start_time: @sales_status.scheduled_start_time,
                               scheduled_end_time: @sales_status.scheduled_end_time,
                               place: @sales_status.place,
                               note: @sales_status.note,
                               external_staff_id: @params_member_id)
      end
    end
end
