class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  # before_action :set_one_month, only: :top
  
  def top
  end

end
