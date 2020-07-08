class Submanager::EventsController < ApplicationController
  before_action :not_current_submanager_return_login!
  before_action :submanager_event_title
  
  def index
    @events = Event.where(manager_id: current_submanager.manager_id).where("event_type = ? or event_type = ?","C","D")
    @submanager_events = SubmanagerEvent.where(submanager_id: current_submanager.id)
  end
end
