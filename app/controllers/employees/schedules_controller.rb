class Employees::SchedulesController < ApplicationController
  before_action :authenticate_admin_or_manager!
  before_action :schedule_member, only: [:new, :edit]
  before_action :set_schedule, only: [:edit, :update, :destroy]
  
  
  def index
    @object_day = Date.current
    set_basic_schedules(@object_day)
  end
  
  def new
    @schedule = Schedule.new
  end
  
  def create
    # 担当者パラメータ整形
    member_in_charge(schedule_params)
    @schedule = Schedule.new(@schedule_params)
    #重複チェック
    unique_schedule_for_create
    if @result != "failure" && @schedule.save
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def show
    @object_day = Schedule.find(params[:id]).scheduled_date
    set_basic_schedules(@object_day)
  end
  
  def edit
    if @schedule.admin_id.present?
      @member_value = "admin##{@schedule.admin_id}"
    elsif @schedule.manager_id.present?
      @member_value = "manager##{@schedule.manager_id}"
    elsif @schedule.staff_id.present?
      @member_value = "staff##{@schedule.staff_id}"
    elsif @schedule.external_staff_id.present?
      @member_value = "external_staff##{@schedule.external_staff_id}"
    end
  end
  
  def update
    # 担当者パラメーター整形
    member_in_charge(schedule_params)
    # 重複チェック
    unique_schedule_for_update(@schedule_params)
    if @result != "failure" && @schedule.update(@schedule_params)
      @object_day = @schedule.scheduled_date
      set_basic_schedules(@object_day)
      @result = "success"
    else
      @result = "failure"
    end
  end
  
  def destroy
    @schedule.destroy
    @object_day = @schedule.scheduled_date
    set_basic_schedules(@object_day)
  end
  
  private
    def set_schedule
      @schedule = Schedule.find(params[:id])
    end
  
    def schedule_params
      params.require(:schedule).permit(:title, 
                                       :scheduled_date,
                                       :scheduled_start_time,
                                       :scheduled_end_time,
                                       :place,
                                       :note)
    end
    
    def set_basic_schedules(day)
      @schedules = Schedule.all.order(:scheduled_start_time)
      @admin_schedules = @schedules.where(scheduled_date: day).where.not(admin_id: nil).group_by{|schedule| schedule[:admin_id]}
      @manager_schedules = @schedules.where(scheduled_date: day).where.not(manager_id: nil).group_by{|schedule| schedule[:manager_id]}
      @staff_schedules = @schedules.where(scheduled_date: day).where.not(staff_id: nil).group_by{|schedule| schedule[:staff_id]}
      @external_staff_schedules = @schedules.where(scheduled_date: day).where.not(external_staff_id: nil).group_by{|schedule| schedule[:external_staff_id]}
    end
    
    def schedule_member
      @members = []
      Admin.all.each do |admin|
        @members << { auth: admin.auth, id: admin.id, name: admin.name }
      end
      Manager.all.each do |manager|
        @members << { auth: manager.auth, id: manager.id, name: manager.name }
      end
      Staff.all.each do |staff|
        @members << { auth: staff.auth, id: staff.id, name: staff.name }
      end
      ExternalStaff.all.each do |external_staff|
        @members << { auth: external_staff.auth, id: external_staff.id, name: external_staff.name }
      end
      return @members
    end
    
    def member_in_charge(schedule_params)
      params_member = params[:schedule][:member].split("#")
      member_authority = params_member[0]
      params_member_id = params_member[1].to_i
      case member_authority
      when "admin"
        admin_id = Admin.find(params_member_id).id
        @schedule_params = schedule_params.merge(admin_id: admin_id)
      when "manager"
        manager_id = Manager.find(params_member_id).id
        @schedule_params = schedule_params.merge(manager_id: manager_id)
      when "staff"
        staff_id = Staff.find(params_member_id).id
        @schedule_params = schedule_params.merge(staff_id: staff_id)
      when "external_staff"
        external_staff_id = ExternalStaff.find(params_member_id).id
        @schedule_params = schedule_params.merge(external_staff_id: external_staff_id)
      end
    end
    
    # 時間重複
  def unique_schedule_for_create
    if @schedule.admin_id.present?
      duplicate_schedule = Schedule.where(admin_id: @schedule.admin_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', @schedule.scheduled_start_time, @schedule.scheduled_end_time)
    elsif @schedule.manager_id.present?
      duplicate_schedule = Schedule.where(manager_id: @schedule.manager_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', @schedule.scheduled_start_time, @schedule.scheduled_end_time)
    elsif @schedule.staff_id.present?
      duplicate_schedule = Schedule.where(staff_id: @schedule.staff_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', @schedule.scheduled_start_time, @schedule.scheduled_end_time)
    elsif @schedule.external_staff_id.present?
      duplicate_schedule = Schedule.where(external_staff_id: @schedule.external_staff_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', @schedule.scheduled_start_time, @schedule.scheduled_end_time)
    end
    if duplicate_schedule.present?
      @schedule.errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
      @result = "failure"
    end
  end
  
  def unique_schedule_for_update(schedule_params)
    object_start_time = Time.zone.parse("2000-01-01 #{schedule_params[:scheduled_start_time]}")
    object_end_time = Time.zone.parse("2000-01-01 #{schedule_params[:scheduled_end_time]}")
    if schedule_params[:admin_id].present?
      duplicate_schedule = Schedule.where.not(id: @schedule.id).where(admin_id: schedule_params[:admin_id], scheduled_date: schedule_params[:scheduled_date])
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
    elsif @schedule.manager_id.present?
      duplicate_schedule = Schedule.where.not(id: @schedule.id).where(manager_id: @schedule.manager_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
    elsif @schedule.staff_id.present?
      duplicate_schedule = Schedule.where.not(id: @schedule.id).where(staff_id: @schedule.staff_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
    elsif @schedule.external_staff_id.present?
      duplicate_schedule = Schedule.where.not(id: @schedule.id).where(external_staff_id: @schedule.external_staff_id, scheduled_date: @schedule.scheduled_date)
                                   .where('scheduled_end_time > ? and ? > scheduled_start_time', object_start_time, object_end_time)
    end
    if duplicate_schedule.present?
      @schedule.errors.add(:scheduled_start_time, "：その時間帯は既に予定があります。")
      @result = "failure"
    end
  end
end
