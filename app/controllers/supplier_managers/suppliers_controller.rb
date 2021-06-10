class SupplierManagers::SuppliersController < ApplicationController
  before_action :authenticate_supplier_manager!
  before_action :set_supplier
  
  
  def update
    if @supplier.update(supplier_params)
      flash[:success] = "外注先を更新しました"
      redirect_to edit_supplier_manager_registration_path(@supplier.supplier_manager)
    end
  end
  
  private
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params.require(:supplier).permit(:name, :kana, :representative, :phone_1, :phone_2, :fax, :email, :postal_code, :prefecture_code, :address_city, :address_street, { :industry_ids=> [] })
    end
end
