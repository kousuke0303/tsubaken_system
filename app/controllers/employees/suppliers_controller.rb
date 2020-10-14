class Employees::SuppliersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:success] = "外注先を作成しました"
      redirect_to employees_supplier_url(@supplier)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      flash[:success] = "外注先情報を更新しました"
      redirect_to employees_supplier_url(@supplier)
    else
      render :edit
    end
  end

  def show
    @matters = @supplier.matters
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
      params.require(:supplier).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :zipcode,
                                       :address, { :industry_ids=> [] })
    end
end
