class Api::V1::Employees::ClientsController < Api::V1::ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :check_token_and_key_to_api
  before_action :set_client, only: [:update, :destroy]

  private
    def set_client
      @client = Staff.find(params[:id])
    end
end
