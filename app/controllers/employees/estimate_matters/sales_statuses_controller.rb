class Employees::EstimateMatters::SalesStatusesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:show, :edit, :update, :destroy]
  before_action :set_statuses, only: [:new, :edit]
  # before_action ->{ set_person_in_charge(@estimate_matter) }, only: [:new, :edit]
  before_action ->{ group_for(@estimate_matter) }, only: [:new, :edit]
  
  def new
    @sales_status = @estimate_matter.sales_statuses.new 
    @type = "new"
  end

  def create
    params[:sales_status][:register_for_schedule] = params[:sales_status][:register_for_schedule].to_i
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)
    @sales_status.login_user = login_user
    if params[:sales_status][:register_for_schedule] == 0
      @sales_status.save
    elsif params[:sales_status][:register_for_schedule] == 1
      @sales_status.set_schedule
    end
    @response = "success"
    common_variable_for_view
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
    params[:sales_status][:register_for_schedule] = params[:sales_status][:register_for_schedule].to_i
    #スケジュールコントロールから遷移してきた場合
    if params[:origin] == "schedule"
      @origin = "schedule"
    end
    
    @sales_status.login_user = login_user
    
    # 元々スケジュール登録なしの場合
    if @sales_status.register_for_schedule == "not_register" || @sales_status.register_for_schedule == "schedule_destroy"
      if params[:sales_status][:register_for_schedule] == 0
        @sales_status.update(sales_status_params)
      else
        @sales_status.update_and_set_schedule(sales_status_params)
      end
    # 元々スケジュール登録ありの場合
    else
      @schedule = Schedule.find_by(sales_status_id: @sales_status.id)
      if params[:sales_status][:register_for_schedule] == 2
        @sales_status.update_and_update_schedule(sales_status_params, @schedule)
      else
        @sales_status.update_and_destroy_schedule(sales_status_params, @schedule)  
      end 
    end
    @response = "success"
    common_variable_for_view
  rescue
    @response = "failure"
  end

  def destroy
    @sales_status.destroy
    common_variable_for_view
  end

  private
    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:status, :scheduled_date, :scheduled_start_time, :scheduled_end_time, :place, :note, :member_code_id, :register_for_schedule)
    end

    def set_statuses
      @statuses = SalesStatus.statuses.except("not_set").keys.map{ |k| [I18n.t("enums.sales_status.status.#{ k }"), k] }
    end
    
    def common_variable_for_view
      @sales_statuses = @estimate_matter.sales_statuses.includes(:sales_status_editor).order(created_at: "DESC")
      @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
    end    
end
