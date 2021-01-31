class Employees::EstimateMattersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_estimate_matter, only: [:show, :edit, :update, :destroy]
  before_action :set_employees, only: [:show, :new, :edit, :person_in_charge]
  before_action :set_publishers, only: [:new, :edit]
  before_action :other_tab_display, only: :progress_table
  before_action :set_three_month, only: [:progress_table, :progress_table_for_three_month]
  before_action :set_six_month, only: :progress_table_for_six_month
  before_action :can_access_only_estimate_matter_of_being_in_charge

  def index
    @sales_statuses = SalesStatus.order(created_at: "DESC")
    current_person_in_charge
    if params[:name].present?
      @estimate_matters = @estimate_matters.get_id_by_name params[:name]
    end
    if params[:year].present? && params[:month].present?
      @estimate_matters = @estimate_matters.get_by_created_at params[:year], params[:month]
    end
  end

  def new
    @estimate_matter = EstimateMatter.new
    @attract_methods = AttractMethod.all
    if params[:client_id]
      client = Client.find(params[:client_id])
      @id = client.id
      @postal_code = client.postal_code
      @prefecture_code = client.prefecture_code
      @address_city = client.address_city
      @address_street = client.address_street
    end
  end

  def create
    @estimate_matter = EstimateMatter.new(estimate_matter_params)
    if @estimate_matter.save
      @estimate_matter.sales_statuses.create!(status: "not_set", conducted_on: Date.current)
      set_estimate_matter_members
      flash[:success] = "見積案件を作成しました。"
      redirect_to employees_estimate_matters_url(id: @estimate_matter.id)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @matter = @estimate_matter.matter
    @publisher = @estimate_matter.publisher
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    @estimates = @estimate_matter.estimates
    @certificates = @estimate_matter.certificates.order(position: :asc)
    @images = @estimate_matter.images.select { |image| image.images.attached? }
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
  end

  def edit
    @attract_methods = AttractMethod.all
    @id = @estimate_matter.client_id
    @postal_code = @estimate_matter.postal_code
    @prefecture_code = @estimate_matter.prefecture_code
    @address_city = @estimate_matter.address_city
    @address_street = @estimate_matter.address_street
  end

  def update
    if @estimate_matter.update(estimate_matter_params)
      set_estimate_matter_members
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

    def set_publishers
      @publishers = Publisher.all
    end

    def estimate_matter_params
      params.require(:estimate_matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :attract_method_id,
                                              :address_street, :publisher_id, :client_id, { staff_ids: [] }, { external_staff_ids: [] })
    end
    
    def current_person_in_charge
      if current_admin || current_manager
        @estimate_matters = EstimateMatter.all.order(created_at: :desc)
      elsif current_staff
        @estimate_matters = current_staff.estimate_matters.order(created_at: :desc)
      elsif current_external_staff
        @estimate_matters = current_external_staff.estimate_matters.order(created_at: :desc)
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
    
    def set_estimate_matter_members
      # 更新用(一度削除しないと重複する)
      if @estimate_matter.estimate_matter_staffs.present?
        @estimate_matter.estimate_matter_staffs.destroy_all
      end
      if @estimate_matter.estimate_matter_external_staffs.present?
        @estimate_matter.estimate_matter_external_staffs.destroy_all
      end
      
      if params[:estimate_matter][:staff_ids].present?
        params[:estimate_matter][:staff_ids].each do |params_staff|
          @estimate_matter.estimate_matter_staffs.create(staff_id: params_staff.to_i) 
        end
      end
      if params[:estimate_matter][:external_staff_ids].present?
        params[:estimate_matter][:external_staff_ids].each do |params_external_staff|
          @estimate_matter.estimate_matter_external_staffs.create(external_staff_id: params_external_staff.to_i) 
        end
      end
    end
end
