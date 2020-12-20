class Employees::EstimateMatters::EstimateMattersController < ApplicationController
  before_action :authenticate_employee!
  
  private
    def set_estimate_matter
      @estimate_matter = EstimateMatter.find(params[:estimate_matter_id])
    end
end
