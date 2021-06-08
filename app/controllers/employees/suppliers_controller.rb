class Employees::SuppliersController < Employees::EmployeesController
  before_action :authenticate_employee!
  before_action :set_suppliers, only: [:index, :show]
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :set_industries, only: [:new, :edit]

  def new
    @supplier = Supplier.new
  end

  def index
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:success] = "外注先を作成しました"
      redirect_to employees_supplier_url(@supplier)
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      flash[:success] = "外注先を更新しました"
      redirect_to employees_supplier_url(@supplier)
    end
  end

  def show
    @supplier_manager = @supplier.supplier_manager
    @external_staffs = @supplier.external_staffs
    @matters = @supplier.matters
    @estimate_matters = @supplier.estimate_matters
  end

  def destroy
    @supplier.destroy ? flash[:success] = "外注先を削除しました" : flash[:alert] = "外注先を削除できませんでした"
    redirect_to employees_suppliers_url
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :postal_code, :prefecture_code, :address_city, :address_street, { :industry_ids=> [] })
    end
end
