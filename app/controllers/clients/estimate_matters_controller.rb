class Clients::EstimateMattersController < ApplicationController
  before_action :authenticate_client!
  before_action :can_access_only_estimate_matter_of_being_in_charge

  def index
    @estimate_matters = current_client.estimate_matters
  end

  def show
    @estimate_matter = EstimateMatter.find(params[:id])
  end
end
