class Managers::ManagersController < ApplicationController
  before_action :authenticate_manager!
  
  def top
  end
end
