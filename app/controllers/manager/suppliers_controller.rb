class Manager::SuppliersController < ApplicationController
  before_action :authenticate_manager!
  before_action :not_current_manager_return_login!
  
  def index
    @suppliers = current_manager.suppliers.for_order_count
  end
  
  def create
    @supplier = dependent_manager.suppliers.build(supplier_params)
    if @supplier.save
      flash[:success] = "取引関係者に#{@supplier.company}を追加しました"
      redirect_to manager_suppliers_url(dependent_manager)
    end
  end
  
  def show
    @supplier = dependent_manager.suppliers.find(params[:id])
  end
  
  def destroy
    @supplier = dependent_manager.suppliers.find(params[:id])
    @supplier.destroy
    flash[:success] = "取引関係者から#{@supplier.company}を削除しました"
    redirect_to manager_suppliers_url(dependent_manager)
  end
  
  private
    def supplier_params
      params.require(:supplier).permit(:company, :location, :representative_name, :phone, :fax, :mail)
    end
end
