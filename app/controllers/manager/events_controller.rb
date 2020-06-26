class Manager::EventsController < ApplicationController
  def index
    @events = Event.where(manager_id: current_manager.id)
  end
end
