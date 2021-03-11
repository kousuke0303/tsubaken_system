class Employees::EstimateMatters::SalesStatusesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:show, :edit, :update, :destroy]
  before_action :set_statuses, only: [:new, :edit]
  before_action ->{ set_person_in_charge(@estimate_matter) }, only: [:new, :edit]
  before_action ->{ group_for(@estimate_matter) }, only: [:new, :edit]
  
  def new
    @sales_status = @estimate_matter.sales_statuses.new 
    @type = "new"
  end

  def create
    # メンバーパラメーター整形
    formatted_member_params(params[:sales_status][:member], sales_status_params)
    params_register_schedule = params[:sales_status][:register_for_schedule].to_i
    @sales_status = @estimate_matter.sales_statuses.new(@final_params.merge(register_for_schedule: params_register_schedule))
    if params_register_schedule == 0
      ActiveRecord::Base.transaction do
        @sales_status.save!
        save_editor
      end
    elsif params_register_schedule == 1
      ActiveRecord::Base.transaction do
        @sales_status.save!(context: :schedule_register)
        save_editor
        schedule_create
      end
    end
    @response = "success"
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
  rescue
    @response = "failure"
  end

  def show
  end
  
  def edit
    if @sales_status.register_for_schedule == "not_register" || @sales_status.register_for_schedule == "schedule_destroy"
      @type = "new"
    end
    #スケジュールコントロールから遷移してきた場合
    if params[:origin] == "schedule"
      @origin = "schedule"
    end
  end

  def update
    # メンバーパラメーター整形
    formatted_member_params(params[:sales_status][:member], sales_status_params)
    params_register_schedule = params[:sales_status][:register_for_schedule].to_i
    #スケジュールコントロールから遷移してきた場合
    if params[:origin] == "schedule"
      @origin = "schedule"
    end
    
    # 元々スケジュール登録なしの場合
    if @sales_status.register_for_schedule == "not_register" || @sales_status.register_for_schedule == "schedule_destroy"
      if params_register_schedule == 0
        ActiveRecord::Base.transaction do
          @sales_status.update!(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
          @sales_status.update!(@final_params.merge(register_for_schedule: params_register_schedule))
          save_editor
        end
      else
        ActiveRecord::Base.transaction do
          @sales_status.update!(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
          @sales_status.update!(@final_params.merge(register_for_schedule: params_register_schedule))
          save_editor
          schedule_create
        end
      end
    # 元々スケジュール登録ありの場合
    else
      @schedule = Schedule.find_by(sales_status_id: @sales_status.id)
      if params_register_schedule == 2
        ActiveRecord::Base.transaction do
          @sales_status.update!(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
          @sales_status.update!(@final_params.merge(register_for_schedule: params_register_schedule))
          schedule_update
          save_editor
        end
      else
        ActiveRecord::Base.transaction do
          @sales_status.update!(admin_id: "", manager_id: "", staff_id: "", external_staff_id: "")
          @sales_status.update!(@final_params.merge(register_for_schedule: params_register_schedule))
          save_editor
          @schedule.destroy
        end
      end 
    end
    @response = "success"
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
  rescue
    @response = "false"
  end

  def destroy
    @sales_status.destroy
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
  end

  private
    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:status, :scheduled_date, :scheduled_start_time, :scheduled_end_time, :place, :note, :register_for_schedule)
    end

    def set_statuses
      @statuses = SalesStatus.statuses.except("not_set").keys.map{ |k| [I18n.t("enums.sales_status.status.#{ k }"), k] }
    end
    
    def save_editor
      if params[:commit] == "作成"
        @sales_status.create_sales_status_editor(authority: login_user.auth, member_id: login_user.id)
      elsif params[:commit] == "更新"
        @sales_status.sales_status_editor.update(authority: login_user.auth, member_id: login_user.id)
      end
    end
    
    def schedule_create
      copy
      Schedule.create!(@params_hash.merge(sales_status_id: @sales_status.id))
    end
    
    def schedule_update
      copy
      @schedule.update_attributes!(@params_hash)
    end
    
    def copy
      title = @sales_status.status_i18n
      @params_hash = @sales_status.attributes
      @params_hash.delete("id")
      @params_hash.delete("estimate_matter_id")
      @params_hash.delete("status")
      @params_hash.delete("register_for_schedule")
      @params_hash.delete("member_name")
      @params_hash.store("title", title) 
    end
end
