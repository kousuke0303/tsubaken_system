class Staff::EventsController < ApplicationController
  before_action :not_current_staff_return_login!
  
  def index
    @events = Event.where(matter_id: current_staff.matters).where("event_type = ? or event_type = ?","C","D")
  end
end
