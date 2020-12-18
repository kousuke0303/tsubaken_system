class Clients::EstimateMattersController < ApplicationController
  before_action :authenticate_client!

  def index
    @estimate_matters = current_client.estimate_matters
  end

  def show
    @estimate_matter = EstimateMatter.find(params[:id])
  end
end
