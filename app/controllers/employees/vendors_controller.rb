class Employees::VendorsController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_vendors, only: [:index, :show]
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]
  before_action :set_industries, only: [:new, :edit]

  def new
    @vendor = Vendor.new
  end

  def index
  end

  def create
    @vendor = Vendor.new(vendor_params)
    if @vendor.save
      flash[:success] = "外注先を作成しました"
      redirect_to employees_vendor_url(@vendor)
    end
  end

  def edit
  end

  def update
    if @vendor.update(vendor_params)
      flash[:success] = "外注先を更新しました"
      redirect_to employees_vendor_url(@vendor)
    end
  end

  def show
    @vendor_manager = @vendor.vendor_manager
    @external_staffs = @vendor.external_staffs
    @matters = @vendor.matters
    @estimate_matters = @vendor.estimate_matters
  end

  def destroy
    @vendor.destroy ? flash[:success] = "外注先を削除しました" : flash[:alert] = "外注先を削除できませんでした"
    redirect_to employees_vendors_url
  end

  private
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    def vendor_params
      params.require(:vendor).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :postal_code, :prefecture_code, :address_city, :address_street, { :industry_ids=> [] })
    end
end
