class Employees::EstimateMattersController < Employees::EmployeesController

  before_action :set_estimate_matter, only: [:show, :edit, :update, :destroy, :change_member, :update_member]
  before_action ->{can_access_only_of_member(@estimate_matter)}, except: :index

  before_action :set_publishers, only: [:new, :edit]
  before_action :set_employees, only: [:new, :show, :edit, :change_member, :update_member]
  before_action :all_staff_and_external_staff_code, only: [:new, :edit, :change_member]

  before_action :set_estimates_with_plan_names_and_label_colors, only: :show
  before_action :set_estimate_details, only: :show
  before_action :set_matter_of_estimate_matter, only: :show
  before_action ->{set_menbers_code_for(@estimate_matter)}, only: :show

  def index
    current_person_in_charge(params)
  end

  def externals
    current_person_in_charge(params)
  end

  def new
    @estimate_matter = EstimateMatter.new
    @clients = Client.all
    @suppliers = Vendor.all
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
    set_estimate_matter_variable
    set_certificate_variable
    @sales_statuses = @estimate_matter.sales_statuses.order(created_at: "DESC")
    set_classified_tasks(@estimate_matter)
    @contracted_estimate_matter = SalesStatus.contracted_estimate_matter(@estimate_matter.id)
    @estimate_details = @estimates.with_estimate_details
    @supplier = @estimate_matter.supplier
    @msg_to_switch_type = @estimate_matter.supplier_id ? "自社案件に切替" : "他社案件に切替"
  end

  def edit
    # @supplier = @estimate_matter.supplier
    @attract_methods = (@supplier = @estimate_matter.supplier) ?  AttractMethod.where.not(id: 1).order(position: :asc) : AttractMethod.where(id: 1)
    # @external_staff_codes_ids = @estimate_matter.member_codes.joins(:external_staff).ids
    case params[:edit_type]
    when "basic"
      @edit_type = "basic"
    when "side"
      @edit_type = "side"
      @suppliers = Vendor.all
    when "staff"
      @edit_type = "staff"
      @staff_codes_ids = @estimate_matter.member_codes.joins(:staff).ids
    when "vendor"
      @edit_type = "vendor"
      @vendors = Vendor.all
    when "vendor_staff"
      @edit_type = "vendor_staff"
      @vendor = Vendor.find(params[:vendor_id])
      @vendor_staff_codes_ids = @vendor.external_staffs.joins(:member_code)
                                                           .select('external_staffs.*, member_codes.id AS member_code_id')
    when "alert"
      @edit_type = "vendor_alert"
      difference_ids = params[:difference].map{|id| id.to_i }
      @alert_vendors = Vendor.where(id: difference_ids)
    end
  end

  def update
    if @estimate_matter.update(estimate_matter_params)
      if params[:estimate_matter][:vendor_ids].present?
        delete_vendor_staff_for_delete_vendor
      end
      if params["redirect"].eql?("matter") #着工案件showから編集時は、着工案件showページにリダイレクト
        flash[:success] = "着工案件を更新しました"
        redirect_to employees_matter_url(@estimate_matter.matter)
      else #営業案件showから編集時は、営業案件showページにリダイレクト
        flash[:success] = "見積案件を更新しました"
        redirect_to employees_estimate_matter_url(@estimate_matter)
      end
    end
  end

  def destroy
    @estimate_matter.destroy ? flash[:success] = "見積案件を削除しました" : flash[:alert] = "見積案件を削除できませんでした"
    redirect_to employees_estimate_matters_url
  end

  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:id])
    end

    def estimate_matter_params
      params.require(:estimate_matter).permit(:title, :content, :postal_code, :prefecture_code, :address_city, :attract_method_id,
                                              :address_street, :publisher_id, :client_id, :supplier_id, { member_code_ids: [] }, { vendor_ids: []})
    end

    def current_person_in_charge(params)
      @sales_statuses = SalesStatus.order(created_at: "DESC")
      if current_admin || current_manager
        @estimate_matters = EstimateMatter.all.order(created_at: :desc).eager_load(:client)
      elsif current_staff
        @estimate_matters = current_staff.estimate_matters.order(created_at: :desc)
      elsif current_external_staff
        @estimate_matters = current_external_staff.estimate_matters.order(created_at: :desc)
      end
      if action_name.eql?("externals")
        @estimate_matters = @estimate_matters.where.not(supplier_id: nil)
      else
        @estimate_matters = @estimate_matters.where(supplier_id: nil)
      end
      @estimate_matters = @estimate_matters.get_id_by_name params[:name] if params[:name].present?
      @estimate_matters = @estimate_matters.get_by_created_at params[:year], params[:month] if params[:year].present? && params[:month].present?
    end

    def delete_estimate_matter_relation_table
      unless params[:estimate_matter][:staff_ids].present?
        @estimate_matter.estimate_matter_staffs.delete_all
      end
      unless params[:estimate_matter][:external_staff_ids].present?
        @estimate_matter.estimate_matter_external_staffs.delete_all
      end
    end

    def delete_vendor_staff_for_delete_vendor
      vendors_ids = @estimate_matter.vendors.ids
      delete_vendor_staffs = @estimate_matter.member_codes.joins(:external_staff)
                                               .where.not(external_staffs: {vendor_id: vendors_ids})
      delete_matter_member_codes = @estimate_matter.estimate_matter_member_codes.where(member_code_id: delete_vendor_staffs)
      delete_matter_member_codes.each do |matter_member_code|
        matter_member_code.destroy
      end
    end

    def set_estimate_matter_variable
      @matter = @estimate_matter.matter
      @address = "#{ @estimate_matter.prefecture_code }#{ @estimate_matter.address_city }#{ @estimate_matter.address_street }"
      @publisher = @estimate_matter.publisher
      @client = @estimate_matter.client
    end

    def set_certificate_variable
      @estimate_matter.cover.present? ?  @cover = @estimate_matter.cover :  @cover = @estimate_matter.build_cover
      @certificates = @estimate_matter.certificates.order(position: :asc)
      @images = @estimate_matter.images.where(certificate_list: true).select { |image| image.image.attached? }
      @cover_image = @estimate_matter.images.find_by(cover_list: true)
    end
end
