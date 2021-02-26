class Clients::EstimateMattersController < ApplicationController
  before_action :authenticate_client!
  before_action :can_access_only_estimate_matter_of_being_in_charge

  def index
    @estimate_matters = current_client.estimate_matters
    @client_matters =  Matter.joins(:estimate_matter).where(estimate_matters: { client_id: current_client.id })
  end

  def show
    @estimate_matter = EstimateMatter.find(params[:id])
    @certificates = @estimate_matter.certificates
  end
end
