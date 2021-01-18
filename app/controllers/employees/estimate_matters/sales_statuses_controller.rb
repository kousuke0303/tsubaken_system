class Employees::EstimateMatters::SalesStatusesController < Employees::EstimateMatters::EstimateMattersController
  before_action :set_estimate_matter
  before_action :set_sales_status, only: [:show, :edit, :update, :destroy]
  before_action :set_statuses, only: [:new, :edit]
  before_action ->{ set_person_in_charge(@estimate_matter) }, only: [:new, :edit]
  before_action :estimate_matter_members, only: [:new, :edit]
  
  def new
    @sales_status = @estimate_matter.sales_statuses.new    
  end

  def create
    @sales_status = @estimate_matter.sales_statuses.new(sales_status_params)
    
    ActiveRecord::Base.transaction do
      @sales_status.save
      member_in_charge
      save_editor
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

  def show
  end
  
  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      @sales_status.update(sales_status_params)
      member_in_charge
      save_editor
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

  def destroy
    @sales_status.destroy
    @sales_statuses = @estimate_matter.sales_statuses.with_practitioner
    respond_to do |format|
      format.js
    end
  end

  private
    def set_sales_status
      @sales_status = SalesStatus.find(params[:id])
    end

    def sales_status_params
      params.require(:sales_status).permit(:status, :conducted_on, :note, :staff_id, :external_staff_id)
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
    
    def member_in_charge
      params_editor = params[:sales_status][:member].split("#")
      params_authority = params_editor[0]
      params_member_id = params_editor[1].to_i
      if params[:commit] == "作成"
        @sales_status.create_sales_status_member(authority: params_authority, member_id: params_member_id)
      elsif params[:commit] == "更新"
        @sales_status_member = @sales_status.sales_status_member
        @sales_status_member.update(authority: params_authority, member_id: params_member_id)
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
          @sales_status_editor.update(authority: current_admin.auth, member_id: current_admin.id)
        elsif current_manager
          @sales_status_editor.update(authority: current_manager.auth, member_id: current_manager.id)
        elsif current_staff
          @sales_status_editor.update(authority: current_staff.auth, member_id: current_staff.id)
        elsif current_external_staff
          @sales_status_editor.update(authority: current_external_staff.auth, member_id: current_external_staff.id)
        end
      end        
    end
end
