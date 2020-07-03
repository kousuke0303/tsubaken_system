class Manager::EventsController < ApplicationController
  before_action :not_current_manager_return_login!
  
  def index
    @events = Event.where(manager_id: current_manager.id)
    @manager_events = ManagerEvent.where(manager_id: current_manager.id)

    ary = ManagerEventTitle.where(manager_id: current_manager.id).pluck(:event_name)
    @manager_event_title = Hash.new(0)
      ary.each do |elem|
        @manager_event_title[elem] += 1
      end
    @manager_event_title = @manager_event_title.sort {|(k1, v1), (k2, v2)| v2 <=> v1 }.to_h.keys
    
   
   end
end
