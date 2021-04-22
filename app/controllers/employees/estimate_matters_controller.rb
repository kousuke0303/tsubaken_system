class Employees::EstimateMattersController < Employees::EmployeesController
  
  before_action :set_estimate_matter, only: [:show, :edit, :update, :destroy, :change_member, :update_member]
  before_action ->{can_access_only_of_member(@estiumate_matter)}, except: :index
  
  before_action :set_publishers, only: [:new, :edit]
  before_action :set_employees, only: [:new, :show, :edit, :change_member, :update_member]
  before_action :all_staff_and_external_staff_code, only: [:new, :edit, :change_member]
  
  before_action :set_estimates_with_plan_names_and_label_colors, only: :show
  before_action :set_estimate_details, only: :show
  before_action :set_matter_of_estimate_matter, only: :show
  before_action ->{set_menbers_code_for(@estimate_matter)}, only: :show
  
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
    @clients = Client.all
    @attract_methods = AttractMethod.order(position: :asc)
    if params[:client_id]
      client = Client.find(params[:client_id])
      @id = client.id
      @title = "#{ client.name } 様邸" 
      @postal_code = client.postal_code
      @prefecture_code = client.prefecture_code
      @address_city = client.address_city
      @address_street = client.address_street
    end
  end

  def create
    params[:estimate_matter][:member_code_ids] = params[:estimate_matter][:staff_ids].push(params[:estimate_matter][:external_staff_ids])
    params[:estimate_matter][:member_code_ids].flatten!
    @estimate_matter = EstimateMatter.new(estimate_matter_params)
    if @estimate_matter.save
      flash[:success] = "見積案件を作成しました"
      redirect_to employees_estimate_matters_url(@estimate_matter)
    end
  end

  def show
    gon.estimate_matter_id = @estimate_matter.id
    @matter = @estimate_matter.matter
    @publisher = @estimate_matter.publisher
    @client = @estimate_matter.client
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    set_classified_tasks(@estimate_matter)
    @cover = @estimate_matter.cover
    @certificates = @estimate_matter.certificates.order(position: :asc)
    @images = @estimate_matter.images.select { |image| image.image.attached? }
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
    @estimate_details = @estimates.with_estimate_details
    @address = "#{ @estimate_matter.prefecture_code }#{ @estimate_matter.address_city }#{ @estimate_matter.address_street }"
  end

  def edit
    @clients = Client.all
    @attract_methods = AttractMethod.order(position: :asc)
    @staff_codes = @estimate_matter.member_codes.joins(:staff).select('member_codes.*')
    @external_staff_codes =  @estimate_matter.member_codes.joins(:external_staff).select('member_codes.*')
    @id = @estimate_matter.client_id
    @postal_code = @estimate_matter.postal_code
    @prefecture_code = @estimate_matter.prefecture_code
    @address_city = @estimate_matter.address_city
    @address_street = @estimate_matter.address_street
  end

  def update
    params[:estimate_matter][:member_code_ids] = params[:estimate_matter][:staff_ids].push(params[:estimate_matter][:external_staff_ids])
    params[:estimate_matter][:member_code_ids].flatten!
    if @estimate_matter.update(estimate_matter_params)
      delete_estimate_matter_relation_table
      flash[:success] = "見積案件を更新しました"
      redirect_to employees_estimate_matter_url(@estimate_matter)
    end
  end

  def destroy
    @estimate_matter.destroy ? flash[:success] = "見積案件を削除しました" : flash[:alert] = "見積案件を削除できませんでした"
    redirect_to employees_estimate_matters_url
  end
  
  def change_member
    if params[:staff_id].present?
      set_staff
    elsif params[:external_staff_id].present?
      target_external_staff
    end
    @staff_codes = @estimate_matter.member_codes.joins(:staff).select('member_codes.*')
    @external_staff_codes =  @estimate_matter.member_codes.joins(:external_staff).select('member_codes.*')
  end
  
  def update_member
    params[:estimate_matter][:member_code_ids] = params[:estimate_matter][:staff_ids].push(params[:estimate_matter][:external_staff_ids])
    params[:estimate_matter][:member_code_ids].flatten!
    @estimate_matter.update(estimate_matter_params)
    delete_estimate_matter_relation_table
    flash[:success] = "#{ @estimate_matter.title }の担当者を変更しました"
    if params[:estimate_matter][:staff_id].present?
      @staff = Staff.find(params[:estimate_matter][:staff_id])
      redirect_to retirement_process_employees_staff_url(@staff)
    elsif params[:estimate_matter][:external_staff_id].present?
      @external_staff = ExternalStaff.find(params[:estimate_matter][:external_staff_id])
      redirect_to retirement_process_employees_external_staff_url(@external_staff)
    end
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:id])
    end

    def estimate_matter_params
      params.require(:estimate_matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :attract_method_id,
                                              :address_street, :publisher_id, :client_id, { member_code_ids: [] })
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
    
    def delete_estimate_matter_relation_table
      unless params[:estimate_matter][:staff_ids].present?
        @estimate_matter.estimate_matter_staffs.delete_all
      end
      unless params[:estimate_matter][:external_staff_ids].present?
        @estimate_matter.estimate_matter_external_staffs.delete_all    
      end
    end
end
