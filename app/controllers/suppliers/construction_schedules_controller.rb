class Suppliers::ConstructionSchedulesController < ApplicationController
  before_action :set_construction_schedule, except: :index
  
  def show
    @construction_schedule_pictures = @construction_schedule.images
  end
  
  private
    def set_construction_schedule
      @construction_schedule = ConstructionSchedule.find(params[:id])
    end

end
