class SupplierManagers::SupplierManagersController < ApplicationController
  before_action :authenticate_supplier_manager!
  
  def top
  end
end
