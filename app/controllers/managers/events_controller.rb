class Managers::EventsController < ApplicationController
  before_action :not_current_return_login!
  before_action :event_title
  
  def index
    @events = Event.where("id = ?", current_manager.id)
    @events = ManagerEvent.where("id = ?", current_manager.id)
  end
end
