class Clients::MattersController < ApplicationController
  before_action :authenticate_client!

  def index
    @matters = current_client.matters
  end

  def show
    @matter = Matter.find(params[:id])
  end
end
