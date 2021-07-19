class Clients::EstimateMattersController < ApplicationController
  before_action :authenticate_client!
  before_action :can_access_only_of_client, only: :show

  def index
    @estimate_matters = current_client.estimate_matters
    @client_matters =  Matter.joins(:estimate_matter).where(estimate_matters: { client_id: current_client.id })
  end

  def show
    @estimate_matter = EstimateMatter.find(params[:id])
    @certificates = @estimate_matter.certificates
  end
  
  private
    def can_access_only_of_client
      unless params[:id].to_s.in?(current_client.estimate_matters.ids) || params[:estimate_matter_id].to_s.in?(current_client.estimate_matters.ids)
        flash[:alert] = "アクセス権限がありません。"
        redirect_to root_path
      end
    end
end
