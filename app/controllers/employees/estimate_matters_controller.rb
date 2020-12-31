class Employees::EstimateMattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_employees, only: [:show, :new, :edit, :person_in_charge]
  before_action :current_estimate_matter
  before_action :other_tab_display, only: :progress_table
  before_action :set_three_month, only: [:progress_table, :progress_table_for_three_month]
  before_action :set_six_month, only: :progress_table_for_six_month
  before_action :can_access_only_estimate_matter_of_being_in_charge

  def index
    @sales_statuses = SalesStatus.with_practitioner
    current_person_in_charge
  end

  def new
    @estimate_matter = EstimateMatter.new
    @attract_methods = AttractMethod.all
  end

  def create
    @estimate_matter = EstimateMatter.new(estimate_matter_params)
    if @estimate_matter.save
      @estimate_matter.sales_statuses.create!(status: "not_set", conducted_on: Date.current)
      flash[:success] = "見積案件を作成しました。"
      redirect_to employees_estimate_matters_url(@estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @matter = @estimate_matter.matter
    @sales_statuses = @estimate_matter.sales_statuses.with_practitioner
    @estimates = @estimate_matter.estimates.with_details
    @materials = Material.of_estimate_matter(@estimate_matter.id)
    @constructions = Construction.of_estimate_matter(@estimate_matter.id)
    @certificates = current_estimate_matter.certificates.where(default: true).order(created_at: "DESC")
    @images = current_estimate_matter.images.select { |image| image.images.attached? }
  end

  def edit
    @attract_methods = AttractMethod.all
  end

  def update
    if @estimate_matter.update(estimate_matter_params)
      flash[:success] = "見積案件を更新しました。"
      redirect_to employees_estimate_matter_url(@estimate_matter)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def destroy
    @estimate_matter.destroy ? flash[:success] = "見積案件を削除しました。" : flash[:alert] = "見積案件を削除できませんでした。"
    redirect_to employees_estimate_matters_url
  end
  
  # 見積案件から案件を作成する前に、担当者を設定する
  def person_in_charge
  end

  def progress_table
    @table_type = "three_month"
    est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    @target_est_matters = est_matters.group_by{|list| list.created_at.month} 
  end
  
  def progress_table_for_three_month
    @table_type = "three_month"
    est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    @target_est_matters = est_matters.group_by{|list| list.created_at.month}
    respond_to do |format|
      format.js
    end
  end
  
  def progress_table_for_six_month
    @table_type = "six_month"
    est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    @target_est_matters = est_matters.group_by{|list| list.created_at.month}
    respond_to do |format|
      format.js
    end
  end
  
  def prev_progress_table
    if params[:table_type] == "three_month"
      @table_type = "three_month"
      set_three_month
    elsif params[:table_type] == "six_month"
      @table_type = "six_month"
      set_six_month
    end
    est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    @target_est_matters = est_matters.group_by{|list| list.created_at.month}
    respond_to do |format|
      format.js
    end
  end
  
  def next_progress_table
    if params[:table_type] == "three_month"
      @table_type = "three_month"
      set_three_month
    elsif params[:table_type] == "six_month"
      @table_type = "six_month"
      set_six_month
    end
    est_matters = EstimateMatter.where(created_at: @first_day..@last_day)
    @target_est_matters = est_matters.group_by{|list| list.created_at.month}
    respond_to do |format|
      format.js
    end
  end
    

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:id])
    end

    def set_employees
      @clients = Client.all
      @staffs = Staff.all
      @external_staffs = ExternalStaff.all
    end

    def estimate_matter_params
      params.require(:estimate_matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :attract_method_id,
                                              :address_street, :client_id, { staff_ids: [] }, { external_staff_ids: [] })
    end
    
    def current_person_in_charge
      if current_admin || current_manager
        @estimate_matters = EstimateMatter.all
      elsif current_staff
        @estimate_matters = current_staff.estimate_matters
      elsif current_external_staff
        @estimate_matters = current_external_staff.estimate_matters
      end
    end

    def set_three_month
      @last_day = params[:date].nil? ? Date.current.end_of_month : params[:date].to_date.end_of_month
      @first_day = @last_day.ago(2.month).beginning_of_month
    end
    
    def set_six_month
      @last_day = params[:date].nil? ? Date.current.end_of_month : params[:date].to_date.end_of_month
      @first_day = @last_day.ago(5.month).beginning_of_month
    end
    
end
