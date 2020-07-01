class Submanager::EventsController < ApplicationController
  before_action :not_current_submanager_return_login!
  
  def index
    @events = Event.where(manager_id: current_submanager.manager_id).where("event_type = ? or event_type = ?","C","D")
  end
end
