class Clients::ClientsController < ApplicationController
  before_action :authenticate_client!
  before_action :matter_default_task_requests, only:[:index]
  before_action :scaffolding_and_order_requests_relevant_or_ongoing, only:[:top]
  
  def top
  end
end
