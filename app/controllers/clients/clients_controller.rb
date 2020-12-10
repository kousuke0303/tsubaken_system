class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  before_action :matter_default_task_requests, only:[:index]
  
  def top
  end
end
