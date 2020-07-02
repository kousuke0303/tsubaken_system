class Manager::EventsController < ApplicationController
  before_action :not_current_manager_return_login!
  
  def index
    @events = Event.where(manager_id: current_manager.id)
  end
end
