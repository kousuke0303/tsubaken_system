class Managers::EventsController < ApplicationController
  before_action :not_current_manager_return_login!
  before_action :manager_event_title
  
  def index
    @events = Event.where("manager_id = ?", current_manager.id)
    @manager_events = ManagerEvent.where("manager_id = ?", current_manager.id)
  end
end