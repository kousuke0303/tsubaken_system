class Admin::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :only_admin!
  before_action :admin_limit_1
  
  def top
  end
  
  def show
    @account_number = Admin.count
    @admins = Admin.all
  end
  
end
