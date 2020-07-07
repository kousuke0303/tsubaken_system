class Manager::SuppliersController < ApplicationController
  before_action :authenticate_manager!
  before_action :not_current_manager_return_login!
  
  def index
    @suppliers = current_manager.suppliers.for_order_count
  end
end
