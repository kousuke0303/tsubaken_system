class Api::V1::Employees::MattersController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api

  private
    def set_matter
      @matter = Matter.find(params[:id])
    end
end
