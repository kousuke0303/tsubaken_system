class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  
  def top
  end
end
