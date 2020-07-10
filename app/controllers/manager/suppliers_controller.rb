class Manager::SuppliersController < ApplicationController
  before_action :authenticate_manager!
  before_action :not_current_manager_return_login!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  
  def index
    @suppliers = dependent_manager.suppliers.for_order_count
    @supplier = dependent_manager.suppliers.build
  end
  
  def create
    @supplier = dependent_manager.suppliers.build(supplier_params)
    if @supplier.save
      flash[:success] = "取引関係者に#{@supplier.company}を追加しました"
      redirect_to manager_suppliers_url(dependent_manager)
    else
      respond_to do |format|
        format.js
      end
    end
  end
  
  def show
  end
  
  def edit
    @btn_type = "update"
  end
  
  def update
    if @supplier.update_attributes(supplier_params)
      flash[:success] = "取引関係者に#{@supplier.company}を更新しました"
      redirect_to manager_supplier_path(dependent_manager, @supplier)
    else
      render :edit
    end      
  end
  
  def destroy
    @supplier.destroy
    flash[:success] = "取引関係者から#{@supplier.company}を削除しました"
    redirect_to manager_suppliers_url(dependent_manager)
  end
  
  private
    def supplier_params
      params.require(:supplier).permit(:company, :location, :representative_name, :phone, :fax, :mail)
    end
    
    def set_supplier
      @supplier = dependent_manager.suppliers.find(params[:id])
    end
end
