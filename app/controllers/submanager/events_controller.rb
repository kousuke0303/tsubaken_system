class Submanager::EventsController < ApplicationController
  def index
    @events = Event.where(manager_id: current_submanager.manager_id).where("event_type = ? or event_type = ?","C","D")
  end
end
