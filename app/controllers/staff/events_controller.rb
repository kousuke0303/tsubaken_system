class Staff::EventsController < ApplicationController
  def index
    @events = Event.where(matter_id: current_staff.matters).where("event_type = ? or event_type = ?","C","D")
  end
end
