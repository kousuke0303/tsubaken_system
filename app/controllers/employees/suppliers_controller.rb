class Employees::SuppliersController < ApplicationController
  before_action :authenticate_employee!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  before_action :set_industries, only: [:new, :edit]

  def new
    @supplier = Supplier.new
  end

  def index
    @suppliers = Supplier.all
  end

  def create
    @supplier = Supplier.new(supplier_params)
    if @supplier.save
      flash[:success] = "外注先を作成しました。"
      redirect_to employees_supplier_url(@supplier)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def edit
  end

  def update
    if @supplier.update(supplier_params)
      flash[:success] = "外注先情報を更新しました。"
      redirect_to employees_supplier_url(@supplier)
    else
      respond_to do |format|
        format.js
      end
    end
  end

  def show
    @matters = @supplier.matters.all
    @external_staffs = @supplier.external_staffs.all
    @external_staff = @supplier.external_staffs.new
  end

  def destroy
    @supplier.destroy ? flash[:success] = "外注先を削除しました。" : flash[:alert] = "外注先を削除できませんでした。"
    redirect_to employees_suppliers_url
  end

  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def set_industries
      @industries = Industry.all
    end

    def supplier_params
      params.require(:supplier).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :zipcode,
                                       :address, { :industry_ids=> [] })
    end
end
